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
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: Column(
                children: [
                  for (final secao in dados.secoes)
                    if (secao.topicos.isNotEmpty)
                      _HistoriaComTopicos(secao: secao)
                    else
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

class _HistoriaComTopicos extends StatelessWidget {
  final Secao secao;

  const _HistoriaComTopicos({
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF252B3A),
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 12),

          _linhaLateral(),

          if (secao.imagem != null) ...[
            const SizedBox(height: 18),
            _ImagemSecao(
              imagem: secao.imagem!,
              proporcao: secao.proporcaoImagem,
            ),
          ],

          if (secao.texto.isNotEmpty) ...[
            const SizedBox(height: 18),
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

          const SizedBox(height: 22),

          _linhaSeparadora(),

          const SizedBox(height: 22),

          for (final topico in secao.topicos)
            _TopicoEmpresa(topico: topico),
        ],
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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF252B3A),
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 12),

          _linhaLateral(),

          if (secao.imagem != null) ...[
            const SizedBox(height: 18),
            _ImagemSecao(
              imagem: secao.imagem!,
              proporcao: secao.proporcaoImagem,
            ),
          ],

          if (secao.texto.isNotEmpty) ...[
            const SizedBox(height: 18),
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
        ],
      ),
    );
  }
}

class _TopicoEmpresa extends StatelessWidget {
  final Topico topico;

  const _TopicoEmpresa({
    required this.topico,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (topico.imagem != null) ...[
            _ImagemTopico(
              imagem: topico.imagem!,
              proporcao: topico.proporcaoImagem,
            ),

            const SizedBox(height: 8),
          ],

          Text(
            topico.titulo,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF252B3A),
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            topico.texto,
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

class _ImagemSecao extends StatelessWidget {
  final String imagem;
  final double proporcao;

  const _ImagemSecao({
    required this.imagem,
    required this.proporcao,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: proporcao,
        child: Image.asset(
          imagem,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _imagemErro();
          },
        ),
      ),
    );
  }
}

class _ImagemTopico extends StatelessWidget {
  final String imagem;
  final double proporcao;

  const _ImagemTopico({
    required this.imagem,
    required this.proporcao,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: proporcao,
        child: Image.asset(
          imagem,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _imagemErro();
          },
        ),
      ),
    );
  }
}

Widget _imagemErro() {
  return Container(
    color: const Color(0xFFE8EAF0),
    alignment: Alignment.center,
    child: const Icon(
      Icons.image_not_supported_outlined,
      size: 40,
      color: Color(0xFF8A91A0),
    ),
  );
}

Widget _linhaLateral() {
  return Container(
    width: 38,
    height: 3,
    decoration: BoxDecoration(
      color: const Color(0xFF4263A6),
      borderRadius: BorderRadius.circular(4),
    ),
  );
}

Widget _linhaSeparadora() {
  return Container(
    width: double.infinity,
    height: 3,
    decoration: BoxDecoration(
      color: const Color(0xFF4263A6),
      borderRadius: BorderRadius.circular(4),
    ),
  );
}
