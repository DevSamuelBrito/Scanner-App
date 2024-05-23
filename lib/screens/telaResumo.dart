import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TelaResumo extends StatelessWidget {
  TelaResumo({super.key});

  final firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getLastSale() async {
    var querySnapshot = await firestore
        .collection('Vendas')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      throw Exception('No Sales Found');
    }
  }

  Future<void> _printScreen() async {
    final doc = pw.Document();

    final snapshot = await getLastSale();

    if (snapshot.data() != null) {
      final data = snapshot.data()!;
      final produtos = List<Map<String, dynamic>>.from(data['produtos']);

      doc.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                // mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Resumo da Venda', style: pw.TextStyle(fontSize: 35)),
                  pw.Text('Nome do Cliente: ${data['nomeCliente']}',style:pw.TextStyle(fontSize: 25)),
                  pw.SizedBox(height: 10),
                  pw.Text('Data: ${data['Data'] ?? "Data não disponível"}',
                      style: pw.TextStyle(fontSize: 25)),
                  pw.Text('Hora: ${data['Time'] ?? "Tempo não disponível"}',
                      style: pw.TextStyle(fontSize: 25)),
                  pw.SizedBox(height: 20),
                  pw.Text('Produtos:',
                      style: pw.TextStyle(fontSize: 25,fontWeight: pw.FontWeight.bold)),
                  ...produtos.map((produto) {
                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Nome do Produto: ${produto['nomeProd']}',style:pw.TextStyle(fontSize: 20)),
                        pw.Text('ID do Produto: ${produto['idProduto']}',style:pw.TextStyle(fontSize: 20)),
                        pw.Text('Quantidade: ${produto['qtd']}',style:pw.TextStyle(fontSize: 20)),
                        pw.SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ],
              ),
            );
          },
        ),
      );

      // Salvar o PDF no dispositivo
      final bytes = await doc.save();
      Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela de Resumos"),
        actions: [
          IconButton(
            onPressed: () => _printScreen(),
            icon: Icon(Icons.picture_as_pdf),
          ),
        ],
      ),
      // body: Center(
      //   child: Text("Clique no ícone PDF para gerar o documento."),
      // ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getLastSale(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No sales found"));
          }
          var data = snapshot.data?.data() as Map<String, dynamic>?;

          if (data == null) {
            return Center(child: Text("No data available"));
          }

          List<dynamic> produtos = data['produtos'];

          return ListView(children: [
            ListTile(
              title: (Text(data['nomeCliente'])),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['Data'] ?? "Data não dísponivel"),
                  Text(data['Time'] ?? "Tempo não dísponível"),
                  SizedBox(height: 30),
                  Text('Produtos:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...produtos.map(
                    (produtos) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nome do Produto: ${produtos['nomeProd']}'),
                          Text('ID do Produto: ${produtos['idProduto']}'),
                          Text('Quantidade: ${produtos['qtd']}'),
                          SizedBox(
                            height: 8,
                          )
                        ],
                      );
                    },
                  )

                  // if (data.containsKey('Amount') && data['sAmount'] != null)
                  //   Text((data['Amount'] as num).toStringAsFixed(1)),
                  // if (data.containsKey('cidade') && data['cidade'] != null)
                  //   Text(data['cidade'] ?? 'Cidade não disponível'),
                  // if (data.containsKey('cnpj') && data['cnpj'] != null)
                  //   Text(data['cnpj'] ?? 'Cnpj não disponível'),
                  // if (data.containsKey('price') && data['price'] != null)
                  //   Text((data['price'] as num).toStringAsFixed(1) ??
                  //       "Preço não dísponível"),
                  // if (data.containsKey('telefone') &&
                  //     data['telefone'] != null)
                  //   Text(data['telefone'] ?? 'Telefone não disponível'),
                ],
              ),
            )
          ]);
        },
      ),
    );
  }
}


//   // Stream<List<DocumentSnapshot>> combiSneStreams() {
//   //   var vendasStream = firestore
//   //       .collection('Vendas')
//   //       .snapshots()
//   //       .map((snapshot) => snapshot.docs);
//   //   var clienteStream = firestore
//   //       .collection('Clientes')
//   //       .snapshots()
//   //       .map((snapshot) => snapshot.docs);

//   //   return CombineLatestStream.list([vendasStream, clienteStream])
//   //       .map((list) => list.expand((x) => x).toList());
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Tela de Resumo"),
//         actions: [
//           IconButton(
//             onPressed: () =>
//                 Navigator.pushReplacementNamed(context, '/cadastroVendas'),
//             icon: Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: getLastSale(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData) {
//             return Center(child: Text("No sales found"));
//           }
//           var data = snapshot.data?.data() as Map<String, dynamic>?;

//           if (data == null) {
//             return Center(child: Text("No data available"));
//           }

//           List<dynamic> produtos = data['produtos'];

//           return ListView(children: [
//             ListTile(
//               title: (Text(data['nomeCliente'])),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(data['Data'] ?? "Data não dísponivel"),
//                   Text(data['Time'] ?? "Tempo não dísponível"),
//                   SizedBox(height: 30),
//                   Text('Produto:',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   ...produtos.map((produtos) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Nome do Produto: ${produtos['nomeProd']}'),
//                         Text('ID do Produto: ${produtos['idProdtuo']}'),
//                         Text('Quantidade: ${produtos['qtd']}'),
//                         SizedBox(
//                           height: 8,
//                         )
//                       ],
//                     );
//                   })

//                   // if (data.containsKey('Amount') && data['sAmount'] != null)
//                   //   Text((data['Amount'] as num).toStringAsFixed(1)),
//                   // if (data.containsKey('cidade') && data['cidade'] != null)
//                   //   Text(data['cidade'] ?? 'Cidade não disponível'),
//                   // if (data.containsKey('cnpj') && data['cnpj'] != null)
//                   //   Text(data['cnpj'] ?? 'Cnpj não disponível'),
//                   // if (data.containsKey('price') && data['price'] != null)
//                   //   Text((data['price'] as num).toStringAsFixed(1) ??
//                   //       "Preço não dísponível"),
//                   // if (data.containsKey('telefone') &&
//                   //     data['telefone'] != null)
//                   //   Text(data['telefone'] ?? 'Telefone não disponível'),
//                 ],
//               ),
//             )
//           ]);
//         },
//       ),
//     );
//   }
// }