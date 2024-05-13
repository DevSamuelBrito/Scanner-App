import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanner_app/screens/updateClientes.dart';

class clientes extends StatelessWidget {
  clientes({super.key});

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clientes"),
      ),
      floatingActionButton: FloatingActionButton( 
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, "/cadastroClientes"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore.collection('Clientes').snapshots(),
        builder: (context, snapshot) {

          if(!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var docs = snapshot.data!.docs;

          return ListView(
            children: docs.map((doc) => Dismissible(
                background: Container(color: Colors.red,),
                onDismissed: (_) { 
                  doc.reference.delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Cliente Excluído com sucesso'),
                    )
                  );
                },
                key: Key(doc.id),
                child: ListTile
                (
                  title: Text(doc['nome']),
                  subtitle: Text(doc['price'].toStringAsFixed(1)),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => updateClientes(docId: doc.id))
                      );
                    },
                  ),
                ),
              ),).toList(),
          );

        }
      )
    );
  }
}