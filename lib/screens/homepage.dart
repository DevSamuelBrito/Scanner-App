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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StylesProntos.colorPadrao,
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
            Expanded(
              child: Center(
                child: Container(
                  child: Image.asset(
                    "lib/images/icon.png",
                    width: 320,
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  CustomIconTextButton(
                    icon: Icons.people,
                    text: 'Clientes',
                    onPressed: () => Navigator.pushNamed(context, "/clientes"),
                  ),
                  SizedBox(height: 20),
                  CustomIconTextButton(
                    icon: Icons.shopping_cart,
                    text: 'Produtos',
                    onPressed: () =>
                        Navigator.pushNamed(context, "/tabelaProdutos"),
                  ),
                  SizedBox(height: 20),
                  CustomIconTextButton(
                    icon: Icons.sell,
                    text: 'Vendas',
                    onPressed: () =>
                        Navigator.pushNamed(context, "/vendasScreen"),
                  ),
                  SizedBox(height: 20),
                  CustomIconTextButton(
                    icon: Icons.qr_code_scanner,
                    text: 'Leitura Produto',
                    onPressed: () => scanAndCheckBarcode(),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomIconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  CustomIconTextButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 225, // Definindo uma largura fixa para o botão
      child: TextButton(
        style: StylesProntos.estiloBotaoPadrao(context),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: Colors.white),
              SizedBox(width: 8),
              Text(
                text,
                style: StylesProntos.textBotao(context, '16', Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
