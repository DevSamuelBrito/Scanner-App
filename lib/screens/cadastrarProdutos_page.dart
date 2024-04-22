import 'package:flutter/material.dart';

class CadastrarProdutosPage extends StatelessWidget {
  CadastrarProdutosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: 240,
            padding: EdgeInsets.symmetric(horizontal: 300),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Descrição",
                  ),
                  keyboardType: TextInputType
                      .emailAddress, // Vai definir o teclado que vai aparecer no dispositivo,
                  // maxLines: 5, //Número máximo de linhas para digitar
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Preço da compra",
                  ),

                  obscureText: true, // Vai mascarar a senha para ninguém ver
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Margem/Markup",
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Lucro",
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Preço de Venda",
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Garantia",
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Marca",
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Referência",
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Validade",
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Comissão %",
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      child: Text("Cadastrar"),
                      onPressed: () {} // A chave para uma função anônima,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    ); // body é o restante em branco da tela
  }
}
