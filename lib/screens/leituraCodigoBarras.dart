import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class LeituraCodigoBarras extends StatefulWidget {
  @override
  _LeituraCodigoBarras createState() => _LeituraCodigoBarras();
}

class _LeituraCodigoBarras extends State<LeituraCodigoBarras> {
  String _scannerResult = 'Resultado do scanner';

  Future<void> scannerCode() async {
    try {
      final scannerResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Cor da linha de escaneamento
        'Cancelar', // Texto de cancelar
        true, // Mostra a linha de escaneamento
        ScanMode.BARCODE, // Modo de escaneamento (Barcode ou QrCode)
      );
      if (!mounted) return;

      setState(() {
        _scannerResult = scannerResult;
      });
    } catch (e) {
      setState(() {
        _scannerResult = 'Erro ao escanear: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leitura Código de Barras'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Resultado:'),
            Text(
              _scannerResult,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => scannerCode(),
              child: Text('Escanear código de barras'),
            ),
          ],
        ),
      ),
    );
  }
}
