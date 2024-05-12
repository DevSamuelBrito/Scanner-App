import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanner_app/screens/atualizacaodeVendas.dart';

class SelecaoVendasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione uma venda'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Vendas').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nenhuma venda encontrada.'));
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['nomeCliente'] ?? ''),
                subtitle: Text(data['Data'] ?? ''),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AtualizacaodeVendas(document),
                      ));
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
