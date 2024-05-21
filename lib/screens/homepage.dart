import 'package:flutter/material.dart';
import '../styles/styles.dart';
<<<<<<< Updated upstream

class HomePage extends StatelessWidget {
=======
//comentario commit
class HomePage extends StatelessWidget {
  
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                  width: 200,
=======
                  width: 220,
>>>>>>> Stashed changes
                ),
              ),
            ),
          ),
<<<<<<< Updated upstream
          SingleChildScrollView(
=======
          Center(
>>>>>>> Stashed changes
            child: Column(
              children: [
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/tabelaProdutos"),
                  child: Text(
                    'Tabela de Produtos',
<<<<<<< Updated upstream
                    style: StylesProntos.textBotao(context, '20', Colors.white),
=======
                    style: StylesProntos.textBotao(context,'20',Colors.white),
>>>>>>> Stashed changes
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/cadastroProdutos"),
                  child: Text(
                    'Registrar Produto',
<<<<<<< Updated upstream
                    style: StylesProntos.textBotao(context, '20', Colors.white),
=======
                    style: StylesProntos.textBotao(context,'20',Colors.white),
>>>>>>> Stashed changes
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/leituraCodigoBarras"),
                  child: Text(
                    'Leitura Produto',
<<<<<<< Updated upstream
                    style: StylesProntos.textBotao(context, '20', Colors.white),
=======
                    style: StylesProntos.textBotao(context,'20',Colors.white),
>>>>>>> Stashed changes
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/cadastroVendas"),
                  child: Text(
                    'Cadastro de Venda',
<<<<<<< Updated upstream
                    style: StylesProntos.textBotao(context, '20', Colors.white),
=======
                    style: StylesProntos.textBotao(context,'20',Colors.white),
>>>>>>> Stashed changes
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/vendasScreen"),
                  child: Text(
                    'Tela de Vendas',
<<<<<<< Updated upstream
                    style: StylesProntos.textBotao(context, '20', Colors.white),
=======
                    style: StylesProntos.textBotao(context,'20',Colors.white),
>>>>>>> Stashed changes
                  ),
                ),
                SizedBox(height: 30),
                TextButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
<<<<<<< Updated upstream
                  onPressed: () => Navigator.pushNamed(context, "/clientes"),
                  child: Text(
                    'Clientes',
                    style: StylesProntos.textBotao(context, '20', Colors.white),
=======
                  onPressed: () =>
                      Navigator.pushNamed(context, "/clientes"),
                  child: Text(
                    'Clientes',
                    style: StylesProntos.textBotao(context,'20',Colors.white),
>>>>>>> Stashed changes
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
<<<<<<< Updated upstream
          ),
        ],
=======
          ), // Aqui estava faltando o fechamento da chave
        ], // Aqui estava faltando a chave de fechamento do children
>>>>>>> Stashed changes
      ),
    );
  }
}
