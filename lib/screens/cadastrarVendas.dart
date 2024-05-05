import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? idPronto;
  String? nomeProd;
  String? qtd;

  Product({this.idPronto, this.nomeProd, this.qtd});
}

class CadastroVendas extends StatefulWidget {
  @override
  _CadastroVendasState createState() => _CadastroVendasState();
}

class _CadastroVendasState extends State<CadastroVendas> {
  final nomeCliente = TextEditingController();
  List<Product> produtos = [];

  void enviarProdutosVendas(BuildContext context) {
    FirebaseFirestore.instance.collection('Vendas').add({
      'nomeCliente': nomeCliente.text,
      'produtos': produtos.map((produto) {
        return {
          'idProduto': produto.idPronto,
          'nomeProd': produto.nomeProd,
          'qtd': produto.qtd,
        };
      }).toList(),
    });

    nomeCliente.clear();
    setState(() {
      produtos.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro Vendas"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeCliente,
              decoration: InputDecoration(
                hintText: 'Insira o nome do cliente',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Column(
              children: produtos.map((produto) {
                return Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Insira o id produto',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        produto.idPronto = value;
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Insira o nome do produto',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        produto.nomeProd = value;
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Quantidade',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        produto.qtd = value;
                      },
                    ),
                    SizedBox(height: 16.0),
                  ],
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  produtos.add(Product());
                });
              },
              child: Text('Adicionar mais um Produto'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => enviarProdutosVendas(context),
              child: Text('Enviar Venda'),
            ),
          ],
        ),
      ),
    );
  }
}
