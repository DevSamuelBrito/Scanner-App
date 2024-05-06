import 'package:flutter/material.dart';
import 'package:scanner_app/screens/cadastrarProdutos_page.dart';

import 'screens/ResumoPage.dart';

class ScannerApp extends StatelessWidget {
  ScannerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/cadastrarProdutos",
      // Definindo as rotas para as telas do app
      routes: {
        "/cadastrarProdutos": (context) =>
            CadastrarProdutosPage(), // rota para a tela cadastro produtos
        "/ResumoPage": (context) => ResumoPage(),
      },
    );
  }
}
