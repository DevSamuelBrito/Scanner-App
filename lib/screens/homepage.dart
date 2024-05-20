import 'package:flutter/material.dart';
import '../styles/styles.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 218, 169, 8),
        title: Text(
          "Bem Vindo",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
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
          SingleChildScrollView(
            child: Column(
              children: [
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/tabelaProdutos"),
                  child: Text(
                    'Tabela de Produtos',
                    style: StylesProntos.textBotao(context, '20', Colors.white),
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/cadastroProdutos"),
                  child: Text(
                    'Registrar Produto',
                    style: StylesProntos.textBotao(context, '20', Colors.white),
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/leituraCodigoBarras"),
                  child: Text(
                    'Leitura Produto',
                    style: StylesProntos.textBotao(context, '20', Colors.white),
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/cadastroVendas"),
                  child: Text(
                    'Cadastro de Venda',
                    style: StylesProntos.textBotao(context, '20', Colors.white),
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/vendasScreen"),
                  child: Text(
                    'Tela de Vendas',
                    style: StylesProntos.textBotao(context, '20', Colors.white),
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () => Navigator.pushNamed(context, "/clientes"),
                  child: Text(
                    'Clientes',
                    style: StylesProntos.textBotao(context, '20', Colors.white),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
