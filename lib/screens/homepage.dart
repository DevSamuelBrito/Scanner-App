import 'package:flutter/material.dart';
import '../styles/styles.dart';
//comentario commit
class HomePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Container(
                child: Image.asset(
                  "lib/images/icon.png",
                  width: 200,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                TextButton(
                  style: StylesProntos.estiloBotao,
                  onPressed: () =>
                      Navigator.pushNamed(context, "/tabelaProdutos"),
                  child: Text(
                    'Tabela de Produtos',
                    style: StylesProntos.textBotao,
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotao,
                  onPressed: () =>
                      Navigator.pushNamed(context, "/cadastroProdutos"),
                  child: Text(
                    'Registrar Produto',
                    style: StylesProntos.textBotao,
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotao,
                  onPressed: () =>
                      Navigator.pushNamed(context, "/leituraCodigoBarras"),
                  child: Text(
                    'Leitura Produto',
                    style: StylesProntos.textBotao,
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotao,
                  onPressed: () =>
                      Navigator.pushNamed(context, "/cadastroVendas"),
                  child: Text(
                    'Cadastro de Venda',
                    style: StylesProntos.textBotao,
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotao,
                  onPressed: () =>
                      Navigator.pushNamed(context, "/vendasScreen"),
                  child: Text(
                    'Tela de Vendas',
                    style: StylesProntos.textBotao,
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotao,
                  onPressed: () =>
                      Navigator.pushNamed(context, "/clientes"),
                  child: Text(
                    'Clientes',
                    style: StylesProntos.textBotao,
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ), // Aqui estava faltando o fechamento da chave
        ], // Aqui estava faltando a chave de fechamento do children
      ),
    );
  }
}
