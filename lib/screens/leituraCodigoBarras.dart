import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanner_app/screens/cadastrarVendas.dart';
import 'package:scanner_app/screens/cadastrarProdutos_page.dart';

class LeituraCodigoBarras extends StatefulWidget {
  @override
  _LeituraCodigoBarrasState createState() => _LeituraCodigoBarrasState();
}

class _LeituraCodigoBarrasState extends State<LeituraCodigoBarras> {
  String barcode = '';
  TextEditingController _barcodeController = TextEditingController();

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
      // O usuário cancelou o scanner, mostrar mensagem e não fazer mais nada
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Leitura de código de barras cancelada.'),
        backgroundColor: Colors.red,
      ));
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
