import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

class cadastroClientes extends StatelessWidget {
  final _txtName = TextEditingController();
  final _txtPrice = TextEditingController();
  final _txtCnpj = MaskedTextController(mask: '00.000.000/0000-00');
  final _txtCidade = TextEditingController();
  final _txtTelefone = MaskedTextController(mask: '(00)00000-0000');

  void _onSaved(BuildContext context) {

    final nameText = _txtName.text.trim();
    if (nameText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Insira um nome para o Cliente.'),
        )
      );
      return;
    }

    final priceText = _txtPrice.text.trim();
    if (priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Por favor, insira um valor para o multiplicador de preço.'),
        ),
      );
      return;
    }
    final price = double.tryParse(priceText);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('O valor do multiplicador de preço deve ser um número válido. (Separador de decimais é um ponto ".")'),
        ),
      );
      return;
    }

    final cnpjText = _txtCnpj.text.trim();
    if (cnpjText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Por favor, insira um CNPJ válido.')
        )
      );
      return;
    }

    final cidadeText = _txtCidade.text.trim();
    if (cidadeText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Por favor, insira uma Cidade')
        )
      );
      return;
    }

    final telefoneText = _txtTelefone.text.trim();
    if (telefoneText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Por favor, insira uma Número da casa')
        )
      );
      return;
    }     

    FirebaseFirestore.instance.collection('Clientes').add({
      'name': _txtName.text,
      'price': price,
      'cnpj': _txtCnpj.text,
      'telefone': _txtTelefone.text,
      'cidade': _txtCidade.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('Cliente cadastrado com sucesso'),
      ),
    );

    Navigator.pushReplacementNamed(context, "/clientes");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Clientes"),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
          
              TextField(
                controller: _txtName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nome do Cliente",
                ),
              ),
          
              TextField(
                controller: _txtPrice,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Multiplicador de preço do Cliente",
                ),
              ),
          
              TextField(
                controller: _txtCnpj,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "CNPJ do Cliente",
                ),
              ),
          
              TextField(
                controller: _txtCidade,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Cidade do Cliente",
                ),
              ),     

              TextField(
                controller: _txtTelefone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Telefone do Cliente",
                ),
              ),    
          
              // Row(
              //   children: [
              
              //     Flexible(
              //       flex: 2,
              //       child: TextField(
              //         controller: _txtRua,
              //         decoration: InputDecoration(
              //           border: OutlineInputBorder(),
              //           hintText: "Rua",
              //         ),
              //       ),
              //     ),
              
              //     Flexible(
              //       flex: 1,
              //       child: TextField(
              //         controller: _txtNumeroCasa,
              //         decoration: InputDecoration(
              //           border: OutlineInputBorder(),
              //           hintText: "Número",
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
          
              Container(
                margin: EdgeInsets.only(top: 10),
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("Salvar"),
                  onPressed: () => _onSaved(context),
                ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
