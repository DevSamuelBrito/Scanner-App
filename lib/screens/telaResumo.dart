import 'package:flutter/material.dart';

class TelaResumo extends StatelessWidget {
  void returnHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/cadastroVendas');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela de Resumos"),
        actions: [
          IconButton(
            onPressed: () => returnHome(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(child:Text('teste')),
    );
  }
}
