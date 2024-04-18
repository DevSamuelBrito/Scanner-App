import 'package:flutter/material.dart';

// Classe para definir estilos pré-prontos
class StylesProntos {
  static const TextStyle titulo = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle textBotao = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static final ButtonStyle estiloBotao = TextButton.styleFrom(
    backgroundColor: Colors.black,
    maximumSize: Size.fromHeight(50), // Define a altura mínima do botão
    fixedSize: Size.fromWidth(300), //
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
