import 'package:flutter/material.dart';
import 'screens/homepage.dart';

class ScannerApp extends StatelessWidget { // criando a classe que vai criar o APP no geral
  const ScannerApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Scanner App",//Titulo do App(Edge)
      routes: {"/home":(context) => HomePage()}, // rota para a tela home
      initialRoute: '/home',
    );
  }
}
