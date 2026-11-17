import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/conteudo.dart';
import '../widgets/header_imagem.dart';

class EmpresaPage extends StatelessWidget {
  final PaginaSimples dados;

  const EmpresaPage({
    super.key,
    required this.dados,
  });

  Future<void> _abrirLink(BuildContext context, String url) async {
    final uri = Uri.tryParse(url.trim());

    if (uri == null ||
        !uri.hasScheme ||
        !(uri.scheme == 'https' || uri.scheme == 'http')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link inválido ou não configurado.'),
        ),
      );
      return;
    }

    try {
      final abriu = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!abriu && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível abrir o link.'),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocorreu um erro ao abrir o site.'),
          ),
        );
      }
    }
  }

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
                      _CardEmpresa(
                        secao: secao,
                        dados: dados,
                        onAbrirLink: () => _abrirLink(
                          context,
                          dados.linkOficialUrl,
                        ),
                      ),
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
  final PaginaSimples dados;
  final VoidCallback onAbrirLink;

  const _CardEmpresa({
    required this.secao,
    required this.dados,
    required this.onAbrirLink,
  });

  @override
  Widget build(BuildContext context) {
    final linkConfigurado = dados.linkOficialUrl.trim().isNotEmpty;

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
          if (secao.titulo == 'QUEM SOMOS') ...[
            const SizedBox(height: 22),
            _CardLinkOficial(
              titulo: dados.linkOficialTitulo,
              onTap: linkConfigurado ? onAbrirLink : null,
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

class _CardLinkOficial extends StatelessWidget {
  final String titulo;
  final VoidCallback? onTap;

  const _CardLinkOficial({
    required this.titulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE1E5ED),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.language_rounded,
            color: Color(0xFF4263A6),
            size: 30,
          ),
          const SizedBox(height: 12),
          Text(
            titulo.isEmpty ? 'Site oficial da empresa' : titulo,
            style: const TextStyle(
              color: Color(0xFF252B3A),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Acesse nosso site oficial para conhecer mais sobre a empresa, nossos projetos e soluções.',
            style: TextStyle(
              color: Color(0xFF555B68),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('CONHEÇA NOSSA EMPRESA'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4263A6),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFB8C1D3),
                disabledForegroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
          errorBuilder: (_, __, ___) => _imagemErro(),
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
          errorBuilder: (_, __, ___) => _imagemErro(),
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
