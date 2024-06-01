import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cadastrarProdutos_page.dart';

class LeituraCodigoBarras extends StatefulWidget {
  @override
  _LeituraCodigoBarras createState() => _LeituraCodigoBarras();
}

class _LeituraCodigoBarras extends State<LeituraCodigoBarras> {
  String barcode = '';
  TextEditingController _barcodeController = TextEditingController();

  Future<String> scanBarcode() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (barcodeScanRes == '-1') {
        return '';
      }
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
    while (true) {
      String scannedBarcode = await scanBarcode();
      if (scannedBarcode.isNotEmpty) {
        bool exists = await checkBarcodeExists(scannedBarcode);
        setState(() {
          barcode = scannedBarcode;
        });
        if (exists) {
          // Código de barras já existe no Firestore
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Código de barras já existe no banco de dados!'),
          ));
          Navigator.of(context).pop();
        } else {
          // Código de barras não existe no Firestore
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Código de barras não encontrado no banco de dados.'),
          ));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CadastrarProdutosPage(
                codigoBarras: scannedBarcode,
              ),
            ),
          );
          break;
        }
      }
    }
  }

  void checkAndFetchBarcode() async {
    String inputBarcode = _barcodeController.text.trim();
    if (inputBarcode.isNotEmpty) {
      bool exists = await checkBarcodeExists(inputBarcode);
      setState(() {
        barcode = inputBarcode;
      });
      if (exists) {
        // Código de barras já existe no Firestore
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Código de barras já existe no banco de dados!'),
        ));
      } else {
        // Código de barras não existe no Firestore
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Código de barras não encontrado no banco de dados.'),
        ));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CadastrarProdutosPage(
              codigoBarras: inputBarcode,
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
        title: Text('Leitor de Código de Barras'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Código de barras: $barcode'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanAndCheckBarcode,
              child: Text('Ler Código de Barras'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _barcodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Digite o código de barras manualmente',
                labelText: 'Código de Barras',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkAndFetchBarcode,
              child: Text('Buscar Código de Barras'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }
}
