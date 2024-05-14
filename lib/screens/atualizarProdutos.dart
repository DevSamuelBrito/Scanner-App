import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'dart:io';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

// Update page
class UpdateProdutosPage extends StatefulWidget {
  final String docId;
  UpdateProdutosPage({required this.docId});

  @override
  State<UpdateProdutosPage> createState() => _UpdateProdutosPageState();
}

class _UpdateProdutosPageState extends State<UpdateProdutosPage> {
  late TextEditingController txtDescricao;
  late MoneyMaskedTextController txtPrecoVenda;
  late TextEditingController txtReferencia;
  late ImagePicker imagePicker;
  File? imageFile;
  Uuid uuid = Uuid();

  @override
  void initState() {
    super.initState();
    txtDescricao = TextEditingController();
    txtPrecoVenda =
        MoneyMaskedTextController(thousandSeparator: '.', precision: 2);
    txtReferencia = TextEditingController();
    imagePicker = ImagePicker();
    load();
  }

  load() async {
    var doc = await FirebaseFirestore.instance
        .collection('Produtos')
        .doc(widget.docId)
        .get();
    var docStorage = await FirebaseStorage.instance.ref('/images');

    if (doc.exists) {
      var data = doc.data();
      if (data != null) {
        txtDescricao.text = data['descricao'] ?? '';
        txtPrecoVenda.text = data['precoVenda'] ?? '';
        txtReferencia.text = data['referencia'] ?? '';

        String imageUrl = data['imageUrl'] ?? '';

        final http.Response response = await http.get(Uri.parse(imageUrl));
        final List<int> imageData = response.bodyBytes;
        setState(() {
          imageFile = File.fromRawPath(Uint8List.fromList(imageData));
        });
      }
    }
  }

  void _UpdateProdutos(BuildContext context) {
    List<String> camposNaoPreenchidos = [];

    if (txtDescricao.text.isEmpty) {
      camposNaoPreenchidos.add("Descrição");
    }

    if (txtPrecoVenda.text.isEmpty) {
      camposNaoPreenchidos.add("Preço de venda");
    }

    if (txtReferencia.text.isEmpty) {
      camposNaoPreenchidos.add("Referência");
    }

    if (imageFile == null) {
      camposNaoPreenchidos.add("Imagem");
    }

    if (camposNaoPreenchidos.isNotEmpty) {
      String mensagem = "Os seguintes campos não foram preenchidos:\n";
      mensagem += camposNaoPreenchidos.join(",\n");

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Campos Obrigatórios"),
            content: Text(mensagem),
            actions: <Widget>[
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    if (camposNaoPreenchidos.isEmpty) {
      String productId = uuid.v4();
      FirebaseFirestore.instance
          .collection('Produtos')
          .doc(widget.docId)
          .update(
        {
          'descricao': txtDescricao.text,
          'precoVenda': txtPrecoVenda.text,
          'referencia': txtReferencia.text,
          'produtoId': productId,
        },
      )..catchError((error) {
          print('Erro ao atualizar o produto: $error');
        });
      Navigator.pop(context);
    }
  }

  FirebaseStorage _storage = FirebaseStorage.instance;

  _pick(ImageSource source) async {
    final XFile? xFile = await imagePicker.pickImage(source: source);

    if (xFile != null) {
      final pickedFile = PickedFile(xFile.path);

      setState(() {
        imageFile = File(pickedFile.path);
      });
      _uploadImageToFirebase(pickedFile.path);
    }
  }

  Future<void> _uploadImageToFirebase(String imagePath) async {
    final storage = FirebaseStorage.instance;
    try {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      await storage.ref('images/$imageName').putString(imagePath);
      String imageUrl = await storage.ref('images/$imageName').getDownloadURL();
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
    }
  }

  void _ShowOpcoesBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.download,
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.camera,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.trash,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Remover',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    imageFile = null;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.grey[200],
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: imageFile != null
                                ? FileImage(imageFile!)
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: IconButton(
                              onPressed: _ShowOpcoesBottomSheet,
                              icon: Icon(
                                PhosphorIcons.pencilSimple,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: txtDescricao,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Descrição",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: txtPrecoVenda,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Preço de Venda",
                    prefixText: "R\$",
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: txtReferencia,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Referência",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: Text(
                      "Atualizar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => _UpdateProdutos(context),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
