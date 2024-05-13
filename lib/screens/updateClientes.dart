import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';  

class updateClientes extends StatelessWidget {

  final String docId;

  updateClientes({required this.docId});

  final _txtName = TextEditingController();
  final _txtPrice = TextEditingController();

  void _onSaved(BuildContext context) {
    final nameText = _txtName.text.trim();
    if (nameText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Insira um nome para o Cliente.'),
        ),
      );
      return;
    }

    final priceText = _txtPrice.text.trim();
    if (priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Por favor, insira um valor para o multiplicador de preço.'),
        ),
      );
      return;
    }

    final price = double.tryParse(priceText);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('O valor do multiplicador de preço deve ser um número válido. (Separador de decimais é um ponto ".")'),
        ),
      );
      return;
    }

    final docId = ModalRoute.of(context)!.settings.arguments as String;

    FirebaseFirestore.instance.collection('Clientes').doc(docId).update({
      'nome': nameText,
      'price': price,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Cliente atualizado com sucesso'),
        ),
      );
      Navigator.pushReplacementNamed(context, "/home");
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Erro ao atualizar cliente: $error'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atualização de Clientes"),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            TextField(
              controller: _txtName,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Nome do Cliente...",
              ),
            ),
            TextField(
              controller: _txtPrice,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Multiplicador de preço do Cliente...",
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: ElevatedButton(
                child: Text("Salvar"),
                onPressed: () => _onSaved(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
