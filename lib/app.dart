import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'screens/cadastroProdutos.dart';
import 'screens/leituraCodigoBarras.dart';
import 'screens/cadastrarVendas.dart';
import 'screens/tabelaProdutos.dart';
import 'screens/cadastroClientes.dart';


class ScannerApp extends StatelessWidget {
  // criando a classe que vai criar o APP no geral
  const ScannerApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Scanner App", //Titulo do App(Edge)
      routes: {
        "/home": (context) => HomePage(),// rota para a tela home
        "/cadastroProdutos": (context) => cadastroProdutos(),// rota para a tela cadastro produtos
        "/leituraCodigoBarras": (context) => leituraCodigoBarras(),// rota para a tela leitura codigo de barras
        "/cadastroVendas": (context) => cadastroVendas(),// rota para a tela leitura cadastro de vendas
        "/tabelaProdutos": (context) => tabelaProdutos(),// rota para a tela leitura tabela de produtos
        "/cadastroClientes": (context) => cadastroClientes(),//rota para a tela de cadastro de clientes
      }, 
      initialRoute: '/home',
    );
  }
}
