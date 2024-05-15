import 'package:flutter/material.dart';

class StylesProntos {
  // Método para calcular o tamanho do texto com base na largura da tela
  static double calculateFontSize(BuildContext context, double baseFontSize) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    return screenWidth * (baseFontSize / 375); // 375 é a largura base para o cálculo
  }

  // Método para calcular a largura do botão com base na largura da tela
  static double calculateButtonWidth(BuildContext context, double baseWidth) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    return screenWidth * (baseWidth / 375); // 375 é a largura base para o cálculo
  }

  // Estilo do título
  static const TextStyle titulo = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Estilo do texto do botão
  static TextStyle textBotao(BuildContext context) {
    final double fontSize = calculateFontSize(context, 12); // 16 é o tamanho base da fonte
    return TextStyle(
      fontSize: fontSize,
      color: Colors.white,
    );
  }

  // Estilo do botão
  static ButtonStyle estiloBotaoPadrao(BuildContext context) {
    final double buttonWidth = calculateButtonWidth(context, 230); // 300 é a largura base do botão
    return TextButton.styleFrom(
      backgroundColor: Color(0xFFDA8208),
      minimumSize: Size(buttonWidth, 50), // Define o tamanho mínimo do botão
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static ButtonStyle estiloBotaoRed(BuildContext context) {
    final double buttonWidth = calculateButtonWidth(context, 230); // 300 é a largura base do botão
    return TextButton.styleFrom(
      backgroundColor: Colors.red,
      minimumSize: Size(buttonWidth, 50), // Define o tamanho mínimo do botão
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static ButtonStyle estiloBotaoVerde(BuildContext context) {
    final double buttonWidth = calculateButtonWidth(context, 230); // 300 é a largura base do botão
    return TextButton.styleFrom(
      backgroundColor: Colors.green,
      minimumSize: Size(buttonWidth, 50), // Define o tamanho mínimo do botão
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
