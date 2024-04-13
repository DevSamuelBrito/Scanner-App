import 'package:flutter/material.dart';

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
              Text('Home'),
              ElevatedButton(
                onPressed: () => {},
                child: Text('Registrar Produto'),
              ),
              ElevatedButton(
                onPressed: () => {},
                child: Text('Verificar Produto'),
              ),
              ElevatedButton(
                onPressed: () => {},
                child: Text('Vender Produto'),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
