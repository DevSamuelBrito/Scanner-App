import "package:flutter/material.dart";
import '../styles/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class cadastroVendas extends StatefulWidget {
  @override
  _cadastroVendasState createState() => _cadastroVendasState();
}

class _cadastroVendasState extends State<cadastroVendas> {
  final qtd = TextEditingController();
  final nomeProd = TextEditingController();
  final idProduto = TextEditingController();
  final nomeCliente = TextEditingController();

  void enviarProdutosVendas(BuildContext context) {
    FirebaseFirestore.instance.collection('Vendas').add({
      'qtd': qtd.text,
      'nomeProd': nomeProd.text,
      'idProduto': idProduto.text,
      'nomeCliente': nomeCliente.text,
    });
    qtd.clear();
    nomeProd.clear();
    idProduto.clear();
    nomeCliente.clear();
  }

  List<Widget> camposProduto = [];

  _cadastroVendasState() {
    camposProduto = [
      TextField(
        controller: idProduto,
        decoration: InputDecoration(
          hintText: 'Insira o id produto',
          border: OutlineInputBorder(),
        ),
      ),
      TextField(
        controller: nomeProd,
        decoration: InputDecoration(
          hintText: 'Insira o nome do produto',
          border: OutlineInputBorder(),
        ),
      ),
      TextField(
        controller: qtd,
        decoration: InputDecoration(
          hintText: 'Quantidade',
          border: OutlineInputBorder(),
        ),
      ),
    ];
  }

  Widget gerarNovosCampo(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: idProduto,
          decoration: InputDecoration(
            hintText: 'Insira o id produto',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: nomeProd,
          decoration: InputDecoration(
            hintText: 'Insira o nome do produto',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: qtd,
          decoration: InputDecoration(
            hintText: 'Quantidade',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro Vendas"),
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: nomeCliente,
              decoration: InputDecoration(
                hintText: 'Insira o nome do cliente',
                border: OutlineInputBorder(),
              ),
            ),
            ...camposProduto,
            ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    camposProduto.add(gerarNovosCampo(
                        context)); // Adicione novos campos à lista
                  },
                );
              },
              child: Text('Adicionar mais um Produto'),
            ),
            ElevatedButton(
              style: StylesProntos.estiloBotao,
              onPressed: () => enviarProdutosVendas(context),
              child: Text(
                'teste',
                style: StylesProntos.textBotao,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
