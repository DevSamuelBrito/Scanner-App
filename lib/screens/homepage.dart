import 'package:flutter/material.dart';
import '../styles/styles.dart';

//comentario commit
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StylesProntos.colorPadrao,
        title: Text(
          "Seja Bem Vindo(a) !",
          style: TextStyle(color: Colors.white, fontSize: 30),
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
                  width: 315,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () => Navigator.pushNamed(context, "/clientes"),
                  child: Text(
                    'Clientes',
                    style: StylesProntos.textBotao(context, '20', Colors.white),
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/tabelaProdutos"),
                  child: Text(
                    'Produtos',
                    style: StylesProntos.textBotao(context, '20', Colors.white),
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/vendasScreen"),
                  child: Text(
                    'Vendas',
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
                SizedBox(height: 100),
              ],
            ),
          ), // Aqui estava faltando o fechamento da chave
        ], // Aqui estava faltando a chave de fechamento do children
      ),
    );
  }
}
