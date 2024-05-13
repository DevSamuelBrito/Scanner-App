import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Update page
class UpdateProdutosPage extends StatefulWidget {
  _UpdateProdutosPageState createState() => _UpdateProdutosPageState();
}

class _UpdateProdutosPageState extends State<UpdateProdutosPage> {
  final txtDescricao = TextEditingController();
  final txtPrecoVenda = TextEditingController();
  final txtReferencia = TextEditingController();
  final imagePicker = ImagePicker();
  File? imageFile;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void _getProduto() async {
    DocumentSnapshot documento =
        await _firestore.collection('Produtos').doc('produtoId').get();
    if (documento != null) {
      txtDescricao.text = documento.get('descricao');
      txtPrecoVenda.text = documento.get('precoVenda');
      txtReferencia.text = documento.get('referencia');
    }
  }

  void _updateProduto() async {
    await _firestore.collection('Produtos').doc('produtoId').update({
      'descricao': txtDescricao.text,
      'precoVenda': txtPrecoVenda.text,
      'referencia': txtReferencia.text,
    });
    Navigator.pop(context);
  }

  // Future<void> _pickImageFromGallery() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     setState(() {
  //       imageFile = File(pickedImage.path);
  //     });
  //     _uploadImageToFirebase(pickedImage.path);
  //   }
  // }

  // Future<void> _captureImageFromCamera() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(source: ImageSource.camera);
  //   if (pickedImage != null) {
  //     setState(() {
  //       imageFile = File(pickedImage.path);
  //     });
  //     _uploadImageToFirebase(pickedImage.path);
  //   }
  // }

  _pick(ImageSource source) async {
    final PickedFile = await imagePicker.pickImage(source: source);

    if (PickedFile != null) {
      setState(
        () {
          imageFile = File(PickedFile.path);
        },
      );
      _uploadImageToFirebase(PickedFile.path);
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
                      PhosphorIcons.camera,
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
                      PhosphorIcons.trash,
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
                    onPressed: () => _updateProduto(),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
