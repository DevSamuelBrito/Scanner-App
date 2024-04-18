import 'package:flutter/material.dart';
import '../styles/styles.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: Container(
        child: (Center(
          child: Column(
            children: [
              Text('Home', style: StylesProntos.titulo),
              TextButton(
                style: StylesProntos.estiloBotao,
                onPressed: () => Navigator.pushNamed(context, "/cadastroProdutos"),
                child:
                    Text('Registrar Produto', style: StylesProntos.textBotao),
              ),
              SizedBox(height: 10),
              TextButton(
                style: StylesProntos.estiloBotao,
                onPressed: () => {},
                child: Text('Leitura Produto', style: StylesProntos.textBotao),
              ),
              // ignore: prefer_const_constructors
              SizedBox(height: 10),
              TextButton(
                style: StylesProntos.estiloBotao,
                onPressed: () => {},
                child:
                    Text('Cadastro de Venda', style: StylesProntos.textBotao),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
