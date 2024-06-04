import 'package:flutter/material.dart';
import '../styles/styles.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanner_app/screens/cadastrarVendas.dart';
import 'package:scanner_app/screens/cadastrarProdutos_page.dart';

//comentario commit
class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String barcode = '';

  Future<String> scanBarcode() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancelar',
        true,
        ScanMode.BARCODE,
      );
      return barcodeScanRes;
    } catch (e) {
      return '';
    }
  }

  Future<bool> checkBarcodeExists(String barcode) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Produtos')
        .where('codigoBarras', isEqualTo: barcode)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.isNotEmpty;
  }

  Future<void> scanAndCheckBarcode() async {
    String scannedBarcode = await scanBarcode();
    if (scannedBarcode == '-1') {
      return;
    }
    if (scannedBarcode.isNotEmpty) {
      bool exists = await checkBarcodeExists(scannedBarcode);
      setState(() {
        barcode = scannedBarcode;
      });
      if (exists) {
        // Código de barras já existe no Firestore
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Código de barras encontrado no banco de dados!'),
          backgroundColor: Colors.green,
        ));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CadastroVendas(scannedBarcode: scannedBarcode),
          ),
        );
      } else {
        // Código de barras não existe no Firestore
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Código de barras não encontrado no banco de dados.'),
          backgroundColor: Colors.red,
        ));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CadastrarProdutosPage(
              codigoBarras: scannedBarcode,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 218, 169, 8),
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
                ElevatedButton(
                  style: StylesProntos.estiloBotaoPadrao(context),
                  onPressed: () => scanAndCheckBarcode(),
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
