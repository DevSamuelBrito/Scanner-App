import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanner_app/styles/styles.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Product {
  String? idPronto;
  String? nomeProd;
  String? qtd;
  TextEditingController controller;

  Product({this.idPronto, this.nomeProd, this.qtd})
      : controller = TextEditingController(text: nomeProd ?? '');
}

class CadastroVendas extends StatefulWidget {
  final String scannedBarcode;

  CadastroVendas({required this.scannedBarcode});
  @override
  _CadastroVendasState createState() => _CadastroVendasState();
}

class _CadastroVendasState extends State<CadastroVendas> {
  final nomeCliente = TextEditingController();
  String? data;
  String? time;
  List<Product> produtos = [];

  @override
  void initState() {
    super.initState();
    // Aqui você pode carregar as informações do produto correspondente ao código de barras
    // Exemplo de como você pode carregar informações do Firestore:
    loadProductDetails(widget.scannedBarcode);
  }

  void loadProductDetails(String barcode) async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('Produtos')
          .doc(barcode)
          .get();

      if (productSnapshot.exists) {
        // Preencha as informações do produto nos campos de produtos
        setState(() {
          produtos.add(Product(
            idPronto: productSnapshot['produtoId'],
            nomeProd: productSnapshot['referencia'],
            qtd: '1', // Pode definir uma quantidade padrão aqui, por exemplo
          ));
        });
      }
    } catch (e) {
      print('Erro ao carregar informações do produto: $e');
    }
  }

  void enviarProdutosVendas(BuildContext context) {
    returnTime();
    if (nomeCliente.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, insira o nome do cliente.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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

  Future<List<DocumentSnapshot>> buscarProdutos(String query) async {
    query = query.toLowerCase();
    var result = await FirebaseFirestore.instance.collection('Produtos').get();

    return result.docs.where((doc) {
      var referencia = doc['referencia'].toString().toLowerCase();
      return referencia.contains(query);
    }).toList();
  }

  Future<List<DocumentSnapshot>> buscarClientes(String query) async {
    query = query.toLowerCase();
    var result = await FirebaseFirestore.instance.collection('Clientes').get();

    return result.docs.where((doc) {
      var nomeCliente = doc['name'].toString().toLowerCase();
      return nomeCliente.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StylesProntos.colorPadrao,
        title: Text(
          "Cadastro Vendas",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TypeAheadFormField<DocumentSnapshot>(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  labelText: 'Insira ou selecione o nome do cliente',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: nomeCliente,
              ),
              suggestionsCallback: (pattern) async {
                return await buscarClientes(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion['name']),
                );
              },
              onSuggestionSelected: (suggestion) {
                setState(() {
                  nomeCliente.text = suggestion['name'];
                });
              },
              noItemsFoundBuilder: (context) => Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Nenhum Cliente encontrado.'),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
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
                        TypeAheadFormField<DocumentSnapshot>(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              labelText:
                                  'Insira ou selecione a referência do produto',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: produto.controller,
                          ),
                          suggestionsCallback: (pattern) async {
                            return await buscarProdutos(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion['referencia']),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            setState(() {
                              produto.idPronto = suggestion.id;
                              produto.nomeProd = suggestion['referencia'];
                              produto.controller.text =
                                  suggestion['referencia'];
                            });
                          },
                          noItemsFoundBuilder: (context) => Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Nenhum produto encontrado.'),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text('Quantidade'),
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
