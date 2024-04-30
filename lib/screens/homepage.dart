import 'package:flutter/material.dart';
import '../styles/styles.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // isso daqui vai centralizar os elementos verticalmente
          children: [
            Center(
              child: Container(
                child: Image.asset(
                  "lib/images/icon.png",
                  width: 200,
                ),
              ),
            ),
            Center(
              child: Column( 
                children: [
                  TextButton(
                    style: StylesProntos.estiloBotao,
                    onPressed: () =>
                        Navigator.pushNamed(context, "/tabelaVendas"),
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
                        Navigator.pushNamed(context, "/cadastroClientes"),
                    child: Text(
                      'Cadastrar um Cliente',
                      style: StylesProntos.textBotao,
                    ),
                  ),
                    
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

