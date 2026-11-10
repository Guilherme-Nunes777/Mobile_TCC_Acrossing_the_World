import 'package:flutter/material.dart';

import '../models/conteudo.dart';
import '../widgets/header_imagem.dart';

class EmpresaPage extends StatelessWidget {
  final PaginaSimples dados;

  const EmpresaPage({
    super.key,
    required this.dados,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderImagem(
              titulo: dados.titulo,
              imagem: dados.imagemHeader,
              voltarAbaixoDoTitulo: true,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                18,
                24,
                18,
                32,
              ),
              child: Column(
                children: [
                  for (final secao in dados.secoes)
                    _CardEmpresa(secao: secao),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardEmpresa extends StatelessWidget {
  final Secao secao;

  const _CardEmpresa({
    required this.secao,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE2E5EC),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            secao.titulo,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF252B3A),
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF4263A6),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(height: 18),

          if (secao.imagem != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  secao.imagem!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFEDF0F6),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 40,
                        color: Color(0xFF7B8498),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 18),
          ],

          Text(
            secao.texto,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 14,
              height: 1.8,
              color: Color(0xFF555B68),
            ),
          ),
        ],
      ),
    );
  }
}

