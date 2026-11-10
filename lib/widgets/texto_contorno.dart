import 'package:flutter/material.dart';

/// Texto branco com contorno preto (títulos dos cabeçalhos)
class TextoContorno extends StatelessWidget {
  final String texto;
  final double tamanho;
  const TextoContorno(this.texto, {super.key, this.tamanho = 64});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          texto,
          style: TextStyle(
            fontSize: tamanho,
            fontWeight: FontWeight.w400,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = Colors.black,
          ),
        ),
        Text(
          texto,
          style: TextStyle(
            fontSize: tamanho,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
