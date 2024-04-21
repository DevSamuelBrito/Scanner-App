import 'package:flutter/material.dart';
import 'package:scanner_app/screens/cadastrarProdutos_page.dart';

class ScannerApp extends StatelessWidget {
  const ScannerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Scanner App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: false,
      ),
      // Definindo as rotas para as telas do app
      routes: {
        "/cadastrarProdutos": (context) =>
            CadastrarProdutosPage(), // rota para a tela cadastro produtos
      },
    );
  }
}
