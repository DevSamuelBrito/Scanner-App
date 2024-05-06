import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class cadastroClientes extends StatelessWidget {
  final _txtName = TextEditingController();
  final _txtPrice = TextEditingController();

  void _onSaved(BuildContext context) {
    FirebaseFirestore.instance.collection('Clientes').add({
      'nome': _txtName.text,
      'price': double.parse(_txtPrice.text),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('Cliente cadastrado com sucesso'),
      )
    );

    Navigator.pushReplacementNamed(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Clientes"),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            TextField(
              controller: _txtName,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Nome do Cliente..."
              ),
            ),
            TextField(
              controller: _txtPrice,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Multiplicador de preço do Cliente..."
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: ElevatedButton(
                child: Text("Salvar"),
                onPressed: () => _onSaved(context),
              ),
            )
          ],)
      )
    );
  }
}
