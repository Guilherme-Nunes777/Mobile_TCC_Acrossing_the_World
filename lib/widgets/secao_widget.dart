import 'package:flutter/material.dart';
import '../models/conteudo.dart';
import 'imagem_asset.dart';

/// Renderiza uma [Secao] do JSON: título, imagem e texto (cada um só aparece se existir).
class SecaoWidget extends StatelessWidget {
  final Secao secao;
  final bool centralizado;

  const SecaoWidget({super.key, required this.secao, this.centralizado = true});

  @override
  Widget build(BuildContext context) {
    final alinhamento = centralizado ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centralizado ? TextAlign.center : TextAlign.left;

    return Column(
      crossAxisAlignment: alinhamento,
      children: [
        if (secao.titulo.isNotEmpty) ...[
          Text(
            secao.titulo,
            textAlign: textAlign,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 12),
        ],
        if (secao.imagem != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ImagemAsset(secao.imagem, fit: BoxFit.cover),
          ),
          const SizedBox(height: 12),
        ],
        if (secao.texto.isNotEmpty)
          Text(
            secao.texto,
            textAlign: textAlign,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
      ],
    );
  }
}
