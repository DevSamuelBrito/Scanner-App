import "package:flutter/material.dart";

class cadastroVendas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro Vendas"),
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Insira o nome do produto',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Insira o',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Insira o nome do produto',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
