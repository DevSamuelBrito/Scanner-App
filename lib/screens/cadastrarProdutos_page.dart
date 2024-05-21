// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'dart:io';
import 'dart:math';

//Comentário
class CadastrarProdutosPage extends StatefulWidget {
  CadastrarProdutosPage({Key? key});

  @override
  _CadastrarProdutosPageState createState() => _CadastrarProdutosPageState();
}

class _CadastrarProdutosPageState extends State<CadastrarProdutosPage> {
  String randomNumbers = '';
  final imagePicker = ImagePicker();
  File? imageFile;
  // Instancie um objeto Uuid
  Uuid uuid = Uuid();

  _pick(ImageSource source) async {
    final PickedFile = await imagePicker.pickImage(source: source);

    if (PickedFile != null) {
      setState(
        () {
          imageFile = File(PickedFile.path);
        },
      );
      // _uploadImageToFirebase(PickedFile.path);
    }
  }

  Future<void> _uploadImageToFirebase(String imagePath) async {
    final storage = FirebaseStorage.instance;
    File file = File(imagePath);
    try {
      String imageName = "images/img-${DateTime.now().toString()}.png";
      await storage.ref(imageName).putFile(file);
      String imageUrl = await storage.ref('images/$imageName').getDownloadURL();
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
    }
  }

  void _generatedRandomNumber() {
    setState(() {
      randomNumbers = List.generate(12, (index) => Random().nextInt(10)).join();
    });
  }

  final txtDescricao = TextEditingController();
  final txtPrecoVenda =
      MoneyMaskedTextController(thousandSeparator: '.', precision: 2);
  final txtReferencia = TextEditingController();

  void _Cadastrar(BuildContext context) {
    //Lista para armazenar os nomes dos campos não preenchidos
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

    //Verifica se o código de barras está vazio
    if (randomNumbers.isEmpty) {
      camposNaoPreenchidos.add("Código de Barras");
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

    if (camposNaoPreenchidos.isEmpty) {
      // Gere um productId único utilizando a função v4 do uuid
      String productId = uuid.v4();
      FirebaseFirestore.instance.collection('Produtos').add(
        {
          'descricao': txtDescricao.text,
          'precoVenda': txtPrecoVenda.text,
          'referencia': txtReferencia.text,
          'codigoBarras': randomNumbers,
          'produtoId': productId,
        },
      ).then((DocumentReference docRef) {
        print('ID do produto cadastrado: $productId');
        // Upload da imagem para o Firebase
        _uploadImageToFirebase(imageFile!.path);

        // Você pode realizar outras operações com o ID do documento aqui, se necessário
      }).catchError((error) {
        // Trate erros, se houver algum
        print('Erro ao cadastrar o produto: $error');
      });
      Navigator.pop(context);
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
                  _pick(ImageSource.gallery);
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
                  _pick(ImageSource.camera);
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
                TextField(
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
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _generatedRandomNumber,
                  child: Text(randomNumbers.isEmpty
                      ? 'Gerar Novo Código de barras'
                      : 'Código de Barras: $randomNumbers'),
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
                      "Cadastrar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => _Cadastrar(context),
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
                      "cancelar",
                      style: TextStyle(color: Colors.white),
                    ),
<<<<<<< Updated upstream
                    onPressed: () => Navigator.pushNamed(context, '/home'),
=======
                    onPressed: () => Navigator.of(context).pop(),
>>>>>>> Stashed changes
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
