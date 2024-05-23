import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scanner_app/screens/atualizarProdutos.dart';

class TelaProduto extends StatelessWidget {
  TelaProduto({super.key});

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tela de Produtos"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
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
                    return ListTile(
                      title: Text(data['descricao']),
                      subtitle: Text(data['precoVenda']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
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
                            icon: Icon(Icons.delete),
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
                    );
                  },
                ).toList(),
              );
            }));
  }
}
