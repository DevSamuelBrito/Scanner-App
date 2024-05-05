// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'dart:math';
import 'dart:io';

class CadastrarProdutosPage extends StatefulWidget {
  const CadastrarProdutosPage({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  _CadastrarProdutosPageState createState() => _CadastrarProdutosPageState();
}

class _CadastrarProdutosPageState extends State<CadastrarProdutosPage> {
  String randomNumbers = '';

  File? imageFile;

  final FirebaseStorage storage = FirebaseStorage.instance;
  bool uploading = false;
  double total = 0;

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  }

  void _generatedRandomNumber() {
    setState(
      () {
        //Gera 12 números aleatórios entre 0 e 9
        randomNumbers =
            List.generate(12, (index) => Random().nextInt(10)).join();
      },
    );
  }

  final txtDescricao = TextEditingController();
  final txtPrecoVenda = TextEditingController();
  final txtReferencia = TextEditingController();

  void _Cadastrar(BuildContext context) {
    FirebaseFirestore.instance.collection('Produtos').add(
      {
        'descricao': txtDescricao.text,
        'precoVenda': txtPrecoVenda.text,
        'referencia': txtReferencia.text,
      },
    );
    Navigator.pop(context);
  }

  Future<UploadTask> _uploadImageToFirebaseStorage(String path) async {
    File file = File(path);
    try {
      //Refêrencia ao local onde a imagem será armazenada no Firebase Storage
      String ref = "images/img-${DateTime.now().toString()}.jpg";

      //Upoload da imagem para o Firebase Storage
      return storage.ref(ref).putFile(file);
    } catch (e) {
      // Em caso de erro, imprime o erro e retorna null
      throw Exception('Erro no upload');
    }
  }

  _pickAndUploadImage() async {
    XFile? file = await getImage();
    if (file != null) {
      UploadTask task = await _uploadImageToFirebaseStorage(file.path);
      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          setState(() {
            uploading = true;
            total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        } else if (snapshot.state == TaskState.success) {
          setState(() => uploading = false);
        }
      });
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
                      PhosphorIcons.upload(PhosphorIconsStyle.regular),
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // _pickAndUploadImage();
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
                onTap: () async {
                  Navigator.of(context).pop();
                  //Tirar foto da câmera
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
                  //Torna a foto Null
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
      body: Center(
        child: Container(
          // padding: EdgeInsets.all(50),
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
                          backgroundImage:
                              imageFile != null ? FileImage(imageFile!) : null,
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
                  keyboardType: TextInputType
                      .emailAddress // Vai definir o teclado que vai aparecer no dispositivo,
                  //maxLines: 5, //Número máximo de linhas para digitar
                  ),
              SizedBox(height: 15),
              TextField(
                controller: txtPrecoVenda,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Preço de Venda",
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              TextField(
                controller: txtReferencia,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Referência",
                ),
              ),
              SizedBox(height: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (randomNumbers.isNotEmpty)
                    BarcodeWidget(
                      data: randomNumbers,
                      barcode: Barcode.code128(),
                      width: 200,
                      height: 100,
                    )
                ],
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _generatedRandomNumber,
                child: Text('Gerar Novo Código de barras'),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text(
                    "Cadastrar",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () =>
                      _Cadastrar(context), // A chave para uma função anônima,
                ),
              ),
            ],
          ),
        ),
      ),
    ); // body é o restante em branco da tela
  }
}
