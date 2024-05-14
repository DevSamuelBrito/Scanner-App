import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                hintText: nomeCliente!.text.isNotEmpty
                    ? nomeCliente?.text
                    : 'Nome do Cliente',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              // Envolve a seção de produtos em um Expanded para ocupar todo o espaço disponível
              child: ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> produto = produtos[index];
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID do Produto:'),
                        TextField(
                          controller:
                              TextEditingController(text: produto['idProduto']),
                          onChanged: (value) {
                            produtos[index]['idProduto'] = value;
                          },
                        ),
                        SizedBox(height: 10.0),
                        Text('Nome do Produto:'),
                        TextField(
                          controller:
                              TextEditingController(text: produto['nomeProd']),
                          onChanged: (value) {
                            produtos[index]['nomeProd'] = value;
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Quantidade:'),
                        TextField(
                          controller:
                              TextEditingController(text: produto['qtd']),
                          onChanged: (value) {
                            produtos[index]['qtd'] = value;
                          },
                        ),
                        SizedBox(height: 10),
                      ]);
                },
              ),
            ),
            if (produtos.isNotEmpty)
              ElevatedButton(
                onPressed: removerUltimosProdutos,
                child: Text('Remover Últimos 3 Produtos'),
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  produtos.add({
                    'idProduto': '',
                    'nomeProd': '',
                    'qtd': '',
                  });
                });
              },
              child: Text('Adicionar mais um Produto'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _AtualizarProdutosVendas(),
              child: Text('Cadastrar Venda'),
            ),
          ],
        ),
      ),
    );
  }
}
