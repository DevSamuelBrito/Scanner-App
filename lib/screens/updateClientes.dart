import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:scanner_app/styles/styles.dart';

class updateClientes extends StatefulWidget {
  final String docId;

  updateClientes({required this.docId});

  @override
  State<updateClientes> createState() => _updateClientesState();
}

class _updateClientesState extends State<updateClientes> {
  @override
  initState() {
    super.initState();
    load();
  }

  load() async {
    var doc = await FirebaseFirestore.instance
        .collection('Clientes')
        .doc(widget.docId)
        .get();
    _txtName.text = doc.data()!['name'];
    _txtPrice.text = doc.data()!['price'].toString();
    _txtCnpj.text = doc.data()!['cnpj'];
    _txtTelefone.text = doc.data()!['telefone'];
    _txtCidade.text = doc.data()!['cidade'];
  }

  final _txtName = TextEditingController();
  final _txtPrice = TextEditingController();
  final _txtCnpj = MaskedTextController(mask: '00.000.000/0000-00');
  final _txtTelefone = MaskedTextController(mask: '(00)00000-0000');
  final _txtCidade = TextEditingController();

  void _onSaved(BuildContext context) {
    final nameText = _txtName.text.trim();
    if (nameText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Insira um nome para o Cliente'),
        ),
      );
      return;
    }

    final priceText = _txtPrice.text.trim();
    if (priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content:
              Text('Por favor, insira um valor para o multiplicador de preço'),
        ),
      );
      return;
    }
    final price = double.tryParse(priceText);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
              'O valor do multiplicador de preço deve ser um número válido. (Separador de decimais é um ponto ".")'),
        ),
      );
      return;
    }

    final cnpjText = _txtCnpj.text.trim();
    if (cnpjText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Por favor, insira um CNPJ válido')));
      return;
    }

    final cidadeText = _txtCidade.text.trim();
    if (cidadeText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Por favor, insira uma Cidade')));
      return;
    }

    final telefoneText = _txtTelefone.text.trim();
    if (telefoneText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Por favor, insira uma Número da casa')));
      return;
    }

    FirebaseFirestore.instance.collection('Clientes').doc(widget.docId).update({
      'name': _txtName.text,
      'price': price,
      'cnpj': _txtCnpj.text,
      'telefone': _txtTelefone.text,
      'cidade': _txtCidade.text,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Cliente atualizado com sucesso'),
        ),
      );

      Navigator.pushReplacementNamed(context, "/clientes");
    }).catchError(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Erro ao atualizar cliente: $error'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 218, 169, 8),
        title: Text(
          "Atualização de Clientes",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            TextField(
              controller: _txtName,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Nome do Cliente"),
              ),
            ),
            SizedBox(height: 10),

            TextField(
              controller: _txtPrice,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Multiplicador de preço do Cliente"),
              ),
            ),
            SizedBox(height: 10),

            TextField(
              controller: _txtCnpj,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("CNPJ do Cliente"),
              ),
            ),
            SizedBox(height: 10),

            TextField(
              controller: _txtCidade,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Cidade do Cliente"),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _txtTelefone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Telefone do Cliente"),
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
            //         ),
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
            // ],
            // ),

            Container(
              margin: EdgeInsets.only(top: 10),
              width: 150,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: Text(
                  "Salvar",
                  style: StylesProntos.textBotao(context, '14', Colors.white),
                ),
                onPressed: () => _onSaved(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
