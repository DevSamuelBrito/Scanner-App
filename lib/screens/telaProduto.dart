import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class TelaProduto extends StatelessWidget {
  TelaProduto({super.key});

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela de Produtos"),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, "/HomePage"),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, "/CadastrarProdutosPage"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore.collection('Produtos').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var doc = docs[index].data();
              return ListTile(
                title: Text(doc['descricao']),
                subtitle: Text('Preço: ${doc['precoVenda']}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navegar para a tela de edição passando o ID do produto como argumento
                    Navigator.pushNamed(context, '/atualizarProdutos',
                        arguments: docs[index].id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
