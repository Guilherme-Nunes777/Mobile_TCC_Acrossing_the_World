import 'package:flutter/material.dart';

import '../models/conteudo.dart';
import '../widgets/header_imagem.dart';

class EmpresaPage extends StatelessWidget {
  final PaginaSimples dados;

  const EmpresaPage({
    super.key,
    required this.dados,
  });

  static const Color azul = Color(0xFF4263A6);
  static const Color texto = Color(0xFF252B3A);
  static const Color secundario = Color(0xFF555B68);

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
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                children: [
                  for (final secao in dados.secoes)
                    _CartaoSecao(secao: secao),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartaoSecao extends StatelessWidget {
  final Secao secao;

  const _CartaoSecao({
    required this.secao,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: EmpresaPage.texto,
            ),
          ),
          const SizedBox(height: 12),
          const _LinhaAzul(largura: 38),

          if (secao.imagem != null) ...[
            const SizedBox(height: 18),
            _Imagem(
              caminho: secao.imagem!,
              proporcao: secao.proporcaoImagem,
            ),
          ],

          if (secao.texto.trim().isNotEmpty) ...[
            const SizedBox(height: 18),
            Text(
              secao.texto,
              style: const TextStyle(
                fontSize: 14,
                height: 1.8,
                color: EmpresaPage.secundario,
              ),
            ),
          ],

          if (secao.topicos.isNotEmpty) ...[
            const SizedBox(height: 22),
            const _LinhaAzul(),
            const SizedBox(height: 22),
            for (final topico in secao.topicos)
              _CartaoTopico(topico: topico),
          ],
        ],
      ),
    );
  }
}

class _CartaoTopico extends StatelessWidget {
  final Topico topico;

  const _CartaoTopico({
    required this.topico,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (topico.imagem != null) ...[
            _Imagem(
              caminho: topico.imagem!,
              proporcao: topico.proporcaoImagem,
            ),
            const SizedBox(height: 12),
          ],
          Text(
            topico.titulo,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
              color: EmpresaPage.texto,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            topico.texto,
            style: const TextStyle(
              fontSize: 14,
              height: 1.8,
              color: EmpresaPage.secundario,
            ),
          ),
        ],
      ),
    );
  }
}

class _Imagem extends StatelessWidget {
  final String caminho;
  final double proporcao;

  const _Imagem({
    required this.caminho,
    required this.proporcao,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: proporcao,
        child: Image.asset(
          caminho,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, error, stack) {
            return Container(
              color: const Color(0xFFE8EAF0),
              alignment: Alignment.center,
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 40,
                color: Color(0xFF8A91A0),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LinhaAzul extends StatelessWidget {
  final double? largura;

  const _LinhaAzul({
    this.largura,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura ?? double.infinity,
      height: 3,
      decoration: BoxDecoration(
        color: EmpresaPage.azul,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
