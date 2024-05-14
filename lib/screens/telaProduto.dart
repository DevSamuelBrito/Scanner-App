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
                children: docs
                    .map(
                      (doc) => Dismissible(
                        background: Container(
                          color: Colors.amber,
                        ),
                        onDismissed: (_) {
                          doc.reference.delete();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.black,
                            content: Text("Produto deletado com sucesso!"),
                          ));
                        },
                        key: Key(doc.id),
                        child: ListTile(
                          title: Text(doc['descricao']),
                          subtitle: Text(doc['precoVenda']),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateProdutosPage(docId: doc.id)));
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            }));
  }
}
