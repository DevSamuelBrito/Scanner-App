import 'package:flutter/material.dart';
import 'package:scanner_app/screens/cadastrarProdutos_page.dart';

class ScannerApp extends StatelessWidget {
  const ScannerApp({Key? key, this.title = "Scanner App"}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      initialRoute: "/cadastrarProdutos",
      // Definindo as rotas para as telas do app
      routes: {
        "/cadastrarProdutos": (context) => const CadastrarProdutosPage(
              title: "Cadastro do Produto",
            ), // rota para a tela cadastro produtos
      },
    );
  }
}
