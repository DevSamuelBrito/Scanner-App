import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanner_app/styles/styles.dart';

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
  String? data;
  String? time;
  List<Product> produtos = [];

  void enviarProdutosVendas(BuildContext context) {
    returnTime();
    // Verifica se o campo do nome do cliente está vazio
    if (nomeCliente.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, insira o nome do cliente.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Verifica se pelo menos um produto foi adicionado à lista
    if (produtos.isEmpty ||
        produtos.any((produto) =>
            produto.idPronto == null ||
            produto.nomeProd == null ||
            produto.qtd == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos do produto.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    FirebaseFirestore.instance.collection('Vendas').add({
      'Data': returnTime()['data'],
      'Time': returnTime()['time'],
      'nomeCliente': nomeCliente.text,
      'produtos': produtos.map((produto) {
        return {
          'idProduto': produto.idPronto,
          'nomeProd': produto.nomeProd,
          'qtd': produto.qtd,
        };
      }).toList(),
      'createdAt': Timestamp.now(),
    });

    nomeCliente.clear();
    setState(() {
      produtos.clear();
    });

    Navigator.pushReplacementNamed(context, '/telaResumo');
  }

  void removerUltimosProdutos() {
    setState(() {
      produtos.removeRange(produtos.length - 1, produtos.length);
    });
  }

  Map<String, dynamic> returnTime() {
    final DateTime dateNow = DateTime.now();
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final timeFormatter = DateFormat('HH:mm');
    final formattedDate = dateFormatter.format(dateNow);
    final formattedTime = timeFormatter.format(dateNow);
    return {"data": formattedDate, "time": formattedTime};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 218, 169, 8),
          title: Text(
            "Cadastro Vendas",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true),
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
            Expanded(
              // Envolve a seção de produtos em um Expanded para ocupar todo o espaço disponível
              child: ListView(
                children: [
                  for (var produto in produtos)
                    Column(
                      children: [
                        Text(
                          'Produto ${produtos.indexOf(produto) + 1}',
                          style: StylesProntos.textBotao(
                              context, '18', Colors.black),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text('Insira o Id produto'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            produto.idPronto = value;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text('Insira o Nome do produto'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            produto.nomeProd = value;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text('Insira a Quantidade'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            produto.qtd = value;
                          },
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (produtos.isNotEmpty)
                  TextButton(
                    style: StylesProntos.pequenoBotaoRed(context),
                    onPressed: removerUltimosProdutos,
                    child: Text(
                      '-',
                      style:
                          StylesProntos.textBotao(context, '20', Colors.white),
                    ),
                  ),
                TextButton(
                  style: StylesProntos.pequenoBotaoVerde(context),
                  onPressed: () {
                    setState(
                      () {
                        produtos.add(Product());
                      },
                    );
                  },
                  child: Text(
                    '+',
                    style: StylesProntos.textBotao(context, '20', Colors.white),
                  ),
                ),
                TextButton(
                  style: StylesProntos.pequenoBotaoBlue(context),
                  onPressed: () => enviarProdutosVendas(context),
                  child: Text(
                    '✓',
                    style: StylesProntos.textBotao(context, '20', Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
