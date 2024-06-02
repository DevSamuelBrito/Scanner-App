import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanner_app/styles/styles.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Product {
  String? idPronto;
  String? nomeProd;
  String? qtd;

  Product({this.idPronto, this.nomeProd, this.qtd});
}

class AtualizacaodeVendas extends StatefulWidget {
  final DocumentSnapshot document;
  AtualizacaodeVendas(this.document);

  @override
  _AtualizacaodeVendasState createState() => _AtualizacaodeVendasState();
}

class _AtualizacaodeVendasState extends State<AtualizacaodeVendas> {
  late TextEditingController? nomeCliente = TextEditingController();
  late List<Map<String, dynamic>> produtos = [];

  Future<void> _AtualizarProdutosVendas() async {
    // Verifica se o campo do nome do cliente está vazio
    if (nomeCliente?.text.isEmpty ?? true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, insira o nome do cliente.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Verifica se o campo de produtos está vazio
    if (produtos.isEmpty ||
        produtos.length == 0 ||
        produtos.any((produto) =>
            produto['idProduto'].isEmpty ||
            produto['nomeProd'].isEmpty ||
            produto['qtd'].isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos do produto.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Atualizar os dados no Firebase
      await FirebaseFirestore.instance
          .collection('Vendas')
          .doc(widget.document.id)
          .update({
        'nomeCliente': nomeCliente?.text,
        'produtos': produtos,
      });
      // Mostrar uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Venda atualizada com sucesso.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      // Mostrar uma mensagem de erro, se houver algum problema
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar venda: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
    Navigator.pushReplacementNamed(context, '/telaResumo');
  }

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> data = widget.document.data() as Map<String, dynamic>;
    nomeCliente = TextEditingController(text: data['nomeCliente']);
    produtos = List<Map<String, dynamic>>.from(data['produtos']);
  }

  void removerUltimosProdutos() {
    setState(() {
      produtos.removeRange(produtos.length - 1, produtos.length);
    });
  }

  Future<void> _scanBarcode(int index) async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancelar',
        true,
        ScanMode.BARCODE,
      );

      if (barcode != '-1') {
        DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('Produtos')
            .doc(barcode)
            .get();

        if (productSnapshot.exists) {
          Map<String, dynamic> productData =
              productSnapshot.data() as Map<String, dynamic>;
          setState(() {
            produtos[index]['idProduto'] = barcode;
            produtos[index]['nomeProd'] = productData['nomeProd'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Produto não encontrado.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Erro ao escanear o código de barras: $e');
    }
  }
  void _selectProductFromList(int index) async {
    DocumentSnapshot? selectedProduct = await showDialog<DocumentSnapshot>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecione um produto'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Produtos').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['descricao'] ?? 'Nome não disponível'),
                      onTap: () {
                        Navigator.pop(context, document);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        );
      },
    );
     if (selectedProduct != null) {
      Map<String, dynamic> productData =
          selectedProduct.data() as Map<String, dynamic>;
      setState(() {
        produtos[index]['idProduto'] = selectedProduct.id;
        produtos[index]['descricao'] = productData['descricao'] ?? '';
      });
    }
  }
  void _showProductSelectionMenu(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Selecionar produto da lista'),
              onTap: () {
                Navigator.pop(context);
                _selectProductFromList(index);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Escanear código de barras'),
              onTap: () {
                Navigator.pop(context);
                _scanBarcode(index);
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 218, 169, 8),
        title: Text(
          "Editar Vendas",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeCliente,
              decoration: InputDecoration(
                label: Text('Nome do Cliente'),
                hintText: nomeCliente!.text.isNotEmpty
                    ? nomeCliente!.text
                    : 'Nome do Cliente',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> produto = produtos[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Editar Produto ${index + 1}',
                        style: StylesProntos.textBotao(
                            context, '18', Colors.black),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                label: Text('ID do Produto'),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              controller: TextEditingController(
                                text: produto['idProduto']?.toString() ?? '',
                              ),
                              onChanged: (value) {
                                produto['idProduto'] = value;
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () => _showProductSelectionMenu(index),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text('Nome do Produto'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        controller: TextEditingController(
                          text: produto['descricao'],
                        ),
                        onChanged: (value) {
                          produtos[index]['descricao'] = value;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text('Quantidade'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        controller: TextEditingController(
                          text: produto['qtd'],
                        ),
                        onChanged: (value) {
                          produtos[index]['qtd'] = value;
                        },
                      ),
                      SizedBox(height: 50),
                    ],
                  );
                },
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
                      style: StylesProntos.textBotao(
                          context, '20', Colors.white),
                    ),
                  ),
                TextButton(
                  style: StylesProntos.pequenoBotaoVerde(context),
                  onPressed: () => setState(() {
                    produtos.add({
                      'idProduto': '',
                      'nomeProd': '',
                      'qtd': '',
                    });
                  }),
                  child: Text(
                    '+',
                    style: StylesProntos.textBotao(
                        context, '20', Colors.white),
                  ),
                ),
                TextButton(
                  style: StylesProntos.pequenoBotaoBlue(context),
                  onPressed: _AtualizarProdutosVendas,
                  child: Text(
                    '✓',
                    style: StylesProntos.textBotao(
                        context, '20', Colors.white),
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
