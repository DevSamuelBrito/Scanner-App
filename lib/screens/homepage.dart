import 'package:flutter/material.dart';
import '../styles/styles.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanner_app/screens/cadastrarVendas.dart';
import 'package:scanner_app/screens/cadastrarProdutos_page.dart';

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

  double getResponsiveIconSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * 0.06; // Ajuste a proporção conforme necessário
  }

  Widget _buildButton(
      {required IconData icon,
      required String label,
      required Function onPressed,
      required BuildContext context}) {
    double iconSize = getResponsiveIconSize(context);
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 1).withOpacity(0.15),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextButton(
          style: StylesProntos.estiloBotaoPadrao(context),
          onPressed: () => onPressed(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: iconSize, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  label,
                  style: StylesProntos.textBotao(context, '16', Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 191, 79, 1),
        title: Text(
          "Seja Bem Vindo!",
          style: TextStyle(
              color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Container(
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Image.asset(
                    "lib/images/icon.png",
                    width: 30,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    SizedBox(height: 40),
                    _buildButton(
                      icon: Icons.people,
                      label: 'Clientes',
                      onPressed: () =>
                          Navigator.pushNamed(context, "/clientes"),
                      context: context,
                    ),
                    SizedBox(height: 25),
                    _buildButton(
                      icon: Icons.shopping_cart,
                      label: 'Produtos',
                      onPressed: () =>
                          Navigator.pushNamed(context, "/tabelaProdutos"),
                      context: context,
                    ),
                    SizedBox(height: 25),
                    _buildButton(
                      icon: Icons.sell,
                      label: 'Vendas',
                      onPressed: () =>
                          Navigator.pushNamed(context, "/vendasScreen"),
                      context: context,
                    ),
                    SizedBox(height: 25),
                    _buildButton(
                      icon: Icons.qr_code_scanner,
                      label: 'Leitura Produto',
                      onPressed: () => scanAndCheckBarcode(),
                      context: context,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
