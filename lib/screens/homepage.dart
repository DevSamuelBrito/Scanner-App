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

  @override
  Widget build(BuildContext context) {
    double iconSize = getResponsiveIconSize(context);

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
            SizedBox(height: 20),
            Container(
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Image.asset(
                    "lib/images/icon.png",
                    width: 300,
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
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: TextButton(
                        style: StylesProntos.estiloBotaoPadrao(context),
                        onPressed: () =>
                            Navigator.pushNamed(context, "/clientes"),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people,
                                  size: iconSize, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Clientes',
                                style: StylesProntos.textBotao(
                                    context, '16', Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: TextButton(
                        style: StylesProntos.estiloBotaoPadrao(context),
                        onPressed: () =>
                            Navigator.pushNamed(context, "/tabelaProdutos"),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart,
                                  size: iconSize, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Produtos',
                                style: StylesProntos.textBotao(
                                    context, '16', Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: TextButton(
                        style: StylesProntos.estiloBotaoPadrao(context),
                        onPressed: () =>
                            Navigator.pushNamed(context, "/vendasScreen"),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sell,
                                  size: iconSize, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Vendas',
                                style: StylesProntos.textBotao(
                                    context, '16', Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: TextButton(
                        style: StylesProntos.estiloBotaoPadrao(context),
                        onPressed: () => scanAndCheckBarcode(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code_scanner,
                                  size: iconSize, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Leitura Produto',
                                style: StylesProntos.textBotao(
                                    context, '16', Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
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
