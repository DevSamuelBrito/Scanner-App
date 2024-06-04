import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scanner_app/screens/atualizarProdutos.dart';
import 'package:scanner_app/styles/styles.dart';

class TelaProduto extends StatelessWidget {
  TelaProduto({Key? key});

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StylesProntos.colorPadrao,
        title: Text(
          "Tela de Produtos",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true, // centraliza o titulo
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: StylesProntos.colorPadrao,
        onPressed: () => Navigator.pushNamed(context, "/cadastroProdutos"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore.collection('Produtos').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          return ListView(
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                return Card(
                  // faz os cartões
                  child: ListTile(
                    title: Text(
                      data['descricao'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ), // deixa as letras mais escuras
                    subtitle: Text(
                      data['precoVenda'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ), // deixa as letras mais escuras
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit,
                              size: 28), // Define o tamanho do ícone como 28
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UpdateProdutosPage(document),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete,
                              size: 28), // Define o tamanho do ícone como 28
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Confirmar exclusão'),
                                content: Text(
                                    'Tem certeza que deseja excluir este produto?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('Produtos')
                                          .doc(document.id)
                                          .delete();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('confirmar'),
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
