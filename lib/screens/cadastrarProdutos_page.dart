// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'dart:io';
import 'dart:math';

class CadastrarProdutosPage extends StatefulWidget {
  const CadastrarProdutosPage({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  _CadastrarProdutosPageState createState() => _CadastrarProdutosPageState();
}

class _CadastrarProdutosPageState extends State<CadastrarProdutosPage> {
  String randomNumbers = '';

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
        'codigoBarras': randomNumbers,
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
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     if (randomNumbers.isNotEmpty)
              //       BarcodeWidget(
              //         data: randomNumbers,
              //         barcode: Barcode.code128(),
              //         width: 200,
              //         height: 100,
              //       )
              //   ],
              // ),
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
