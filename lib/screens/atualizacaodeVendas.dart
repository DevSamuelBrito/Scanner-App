import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< Updated upstream
import 'package:scanner_app/styles/styles.dart';
=======
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
        backgroundColor: Color.fromARGB(255, 218, 169, 8),
        title: Text("Editar Vendas"),
        centerTitle: true,
=======
        title: Text("Cadastro Vendas"),
>>>>>>> Stashed changes
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeCliente,
              decoration: InputDecoration(
<<<<<<< Updated upstream
                label: Text('Nome do Cliente'),
=======
>>>>>>> Stashed changes
                hintText: nomeCliente!.text.isNotEmpty
                    ? nomeCliente?.text
                    : 'Nome do Cliente',
                border: OutlineInputBorder(),
              ),
            ),
<<<<<<< Updated upstream
            SizedBox(height: 24),
            Expanded(
=======
            SizedBox(height: 16.0),
            Expanded(
              // Envolve a seção de produtos em um Expanded para ocupar todo o espaço disponível
>>>>>>> Stashed changes
              child: ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> produto = produtos[index];
                  return Column(
<<<<<<< Updated upstream
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Editar Produto ${produtos.indexOf(produto) + 1}',
                        style: StylesProntos.textBotao(
                            context, '18', Colors.black),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
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
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text('Nome do Produto'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        controller:
                            TextEditingController(text: produto['nomeProd']),
                        onChanged: (value) {
                          produtos[index]['nomeProd'] = value;
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
                        controller: TextEditingController(text: produto['qtd']),
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
                      style:
                          StylesProntos.textBotao(context, '20', Colors.white),
                    ),
                  ),
                TextButton(
                  style: StylesProntos.pequenoBotaoVerde(context),
                  onPressed: () {
                    setState(
                      () {
                        produtos.add({
                          'idProduto': '',
                          'nomeProd': '',
                          'qtd': '',
                        });
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
                  onPressed: () => _AtualizarProdutosVendas(),
                  child: Text(
                    '✓',
                    style: StylesProntos.textBotao(context, '20', Colors.white),
                  ),
                ),
              ],
=======
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
>>>>>>> Stashed changes
            ),
          ],
        ),
      ),
    );
  }
}
