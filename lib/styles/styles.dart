import 'package:flutter/material.dart';

// Classe para definir estilos pré-prontos
class StylesProntos {
  static const TextStyle titulo = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  static const TextStyle emphasizedStyle = TextStyle(
    fontSize: 16,
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );

  static ElevatedButton buildTestButton(Text texto) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      child: Text('${texto}'),
    );
  }

}

