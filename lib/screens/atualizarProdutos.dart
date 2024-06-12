// ignore_for_file: prefer_const_constructors
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
import 'package:uuid/uuid.dart';

// Update page
class UpdateProdutosPage extends StatefulWidget {
  final String document;
  UpdateProdutosPage({required this.document});

  @override
  State<UpdateProdutosPage> createState() => _UpdateProdutosPageState();
}

class _UpdateProdutosPageState extends State<UpdateProdutosPage> {
  late TextEditingController txtDescricao;
  late MoneyMaskedTextController txtPrecoVenda;
  late TextEditingController txtReferencia;
  late ImagePicker imagePicker;
  late String newImageUrl;
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
    // newImageUrl = widget.document['imageUrl'];
    load();
  }

  load() async {
    var doc = await FirebaseFirestore.instance
        .collection('Produtos')
        .doc(widget.document)
        .get();
    txtDescricao.text = doc.data()!['descriçao'];
    txtPrecoVenda.text = doc.data()!['precoVenda'];
    txtReferencia.text = doc.data()!['referenica'];
    newImageUrl = doc.data()!['imageUrl'];
  }

  void _UpdateProdutos(BuildContext context) async {
    List<String> camposNaoPreenchidos = [];

    //Verifica se o campo de descrição está vazio
    if (txtDescricao.text.isEmpty) {
      camposNaoPreenchidos.add("Descrição");
    }

    //Verifica se o campo de preço de venda está vazio
    if (txtPrecoVenda.text.isEmpty) {
      camposNaoPreenchidos.add("Preço de venda");
    }

    //Verifica se o campo de Refêrencia está vazio
    if (txtReferencia.text.isEmpty) {
      camposNaoPreenchidos.add("Referência");
    }

    //Verifica se a imagem está vazia
    if (imageFile == null) {
      camposNaoPreenchidos.add("Imagem");
    }

    //Se houver campos não preenchidos, mostra o dialogo de alerta
    if (camposNaoPreenchidos.isNotEmpty) {
      //Monsta a mensagem de alerta com os nomes dos campos não preenchidos
      String mensagem = "Os seguintes campos não foram preenchidos:\n";
      mensagem += camposNaoPreenchidos.join(",\n");

      //Mostra o Dialogo de alerta
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
      return; //Sai do método caso haja campos não preenchidos
    }

    if (imageFile != null) {
      String ImageUrl = await _uploadImageToFirebase(imageFile!.path);
      String productId = uuid.v4();
      FirebaseFirestore.instance.collection('Produtos').add(
        {
          'descricao': txtDescricao.text,
          'precoVenda': txtPrecoVenda.text,
          'referencia': txtReferencia.text,
          'produtoId': productId,
          'imageUrl': newImageUrl,
        },
      );
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Erro ao cadastrar produto"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('ok'),
                )
              ],
            );
          });
    }
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  _pick(ImageSource source) async {
    final PickedFile = await imagePicker.pickImage(source: source);

    if (PickedFile != null) {
      setState(() {
        imageFile = File(PickedFile.path);
      });
      _uploadImageToFirebase(PickedFile.path);
    }
  }

  Future<String> _uploadImageToFirebase(String imagePath) async {
    final storage = FirebaseStorage.instance;
    File file = File(imagePath);
    try {
      String imageName = "images/img-${DateTime.now().toString()}.png";
      await storage.ref(imageName).putFile(file);
      String imageUrl = await storage.ref(imageName).getDownloadURL();
      setState(() {
        newImageUrl = imageUrl;
      });
      return imageUrl;
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
      return '';
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
                      PhosphorIcons.download(),
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // _pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.camera(),
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // _pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.trash(),
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Remover',
                  style: Theme.of(context).textTheme.bodyLarge,
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
                            backgroundImage: NetworkImage(newImageUrl),
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
                                PhosphorIcons.pencilSimple(),
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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    )
                  ],
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
