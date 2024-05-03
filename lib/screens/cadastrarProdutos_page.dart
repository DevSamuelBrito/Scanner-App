// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:io';

class CadastrarProdutosPage extends StatefulWidget {
  const CadastrarProdutosPage({{super.key required this.title},},);

  final imagePicker = ImagePicker();
  File? imageFile;

  pick(ImageSource source) async {
   final pickedFile = await imagePicker.pickImage(source: 
    source);
  if(pickedFile != null){
    setState(() {
      imageFile = pickedFile.path

    },);
  }
  }

  final txtDescricao = TextEditingController();
  final txtPrecoCompra = TextEditingController();
  final txtPrecoVenda = TextEditingController();
  final txtGarantia = TextEditingController();
  final txtMarca = TextEditingController();
  final txtReferencia = TextEditingController();
  final txtValidade = TextEditingController();
  final txtComissao = TextEditingController();

  void _Cadastrar(BuildContext context) {
    FirebaseFirestore.instance.collection('Produtos').add(
      {
        'descricao': txtDescricao.text,
        'precoCompra': txtPrecoCompra.text,
        'precoVenda': txtPrecoVenda.text,
        'garantia': txtGarantia.text,
        'marca': txtMarca.text,
        'referencia': txtReferencia.text,
        'validade': txtValidade.text,
        'comissao': txtComissao.text,
      },
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                        PhosphorIcons.download(PhosphorIconsStyle.regular),
                      ),
                    ),
                  ),
                  title: Text(
                    'Galeria',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    //Buscar a Imagem da galeria
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
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
