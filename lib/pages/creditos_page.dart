import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/conteudo.dart';
import '../widgets/header_imagem.dart';

class CreditosPage extends StatelessWidget {
  final PaginaSimples dados;

  const CreditosPage({
    super.key,
    required this.dados,
  });

  Future<void> _abrirLink(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);

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
            content: Text('Não foi possível abrir o endereço.'),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocorreu um erro ao abrir o endereço.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final professores = dados.professores;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeaderImagem(
                titulo: dados.titulo,
                imagem: dados.imagemHeader,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _tituloSecao(
                      Icons.school_rounded,
                      'Professores orientadores',
                    ),
                    const SizedBox(height: 16),
                    _gradePessoas(professores),
                    if (dados.referencias.isNotEmpty) ...[
                      const SizedBox(height: 30),
                      _tituloSecao(
                        Icons.menu_book_rounded,
                        'Referências',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Fontes utilizadas como base para o desenvolvimento do projeto.',
                        style: TextStyle(
                          color: Color(0xFF64708D),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (final referencia in dados.referencias)
                        _CardRecurso(
                          titulo:
                              referencia['titulo']?.toString() ?? '',
                          descricao:
                              referencia['descricao']?.toString() ?? '',
                          url: referencia['url']?.toString() ?? '',
                          tipo: 'Referência',
                          icone: Icons.link_rounded,
                          onTap: () => _abrirLink(
                            context,
                            referencia['url']?.toString() ?? '',
                          ),
                        ),
                    ],
                    if (dados.documentos.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _tituloSecao(
                        Icons.folder_open_rounded,
                        'Documentos e materiais',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Acesse materiais complementares e arquivos relacionados ao projeto.',
                        style: TextStyle(
                          color: Color(0xFF64708D),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (final documento in dados.documentos)
                        _CardRecurso(
                          titulo:
                              documento['titulo']?.toString() ?? '',
                          descricao:
                              documento['descricao']?.toString() ?? '',
                          url: documento['url']?.toString() ?? '',
                          tipo: documento['tipo']?.toString() ?? 'Arquivo',
                          icone: Icons.description_outlined,
                          onTap: () => _abrirLink(
                            context,
                            documento['url']?.toString() ?? '',
                          ),
                        ),
                    ],
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.favorite_rounded,
                            color: Color(0xFF5368CE),
                            size: 28,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Agradecemos a todos que contribuíram '
                            'para a realização deste projeto!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF64708D),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tituloSecao(IconData icone, String titulo) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF5368CE).withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icone,
            color: const Color(0xFF5368CE),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              color: Color(0xFF202B46),
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _gradePessoas(List<Map<String, dynamic>> pessoas) {
    if (pessoas.isEmpty) {
      return const Text(
        'Nenhum professor cadastrado.',
        style: TextStyle(color: Color(0xFF64708D)),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final largura = constraints.maxWidth;
        final colunas = largura >= 850
            ? 3
            : largura >= 540
                ? 2
                : 1;

        const espacamento = 14.0;
        final larguraCard =
            (largura - espacamento * (colunas - 1)) / colunas;

        return Wrap(
          spacing: espacamento,
          runSpacing: espacamento,
          children: pessoas.map((pessoa) {
            return SizedBox(
              width: larguraCard,
              child: _PessoaCard(pessoa: pessoa),
            );
          }).toList(),
        );
      },
    );
  }
}

class _CardRecurso extends StatelessWidget {
  final String titulo;
  final String descricao;
  final String url;
  final String tipo;
  final IconData icone;
  final VoidCallback onTap;

  const _CardRecurso({
    required this.titulo,
    required this.descricao,
    required this.url,
    required this.tipo,
    required this.icone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE6EAF3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: url.isEmpty ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF5368CE).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icone,
                  color: const Color(0xFF5368CE),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tipo,
                      style: const TextStyle(
                        color: Color(0xFF5368CE),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      titulo.isEmpty ? 'Material sem título' : titulo,
                      style: const TextStyle(
                        color: Color(0xFF202B46),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (descricao.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        descricao,
                        style: const TextStyle(
                          color: Color(0xFF64708D),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.open_in_new_rounded,
                color: url.isEmpty
                    ? Colors.grey.shade400
                    : const Color(0xFF5368CE),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PessoaCard extends StatelessWidget {
  final Map<String, dynamic> pessoa;

  const _PessoaCard({
    required this.pessoa,
  });

  @override
  Widget build(BuildContext context) {
    final nome = (pessoa['nome'] ?? '').toString();
    final foto = (pessoa['foto'] ?? '').toString();
    final detalhe = (pessoa['matéria'] ?? '').toString();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE6EAF3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: SizedBox(
                width: 100,
                height: 100,
                child: foto.isEmpty
                    ? _fotoAlternativa()
                    : Image.asset(
                        foto,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _fotoAlternativa(),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            nome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF202B46),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _materiasWidget(context, detalhe),
        ],
      ),
    );
  }

  Widget _fotoAlternativa() {
    return Container(
      color: const Color(0xFFEDF0F6),
      alignment: Alignment.center,
      child: const Icon(
        Icons.school_rounded,
        size: 42,
        color: Color(0xFF5368CE),
      ),
    );
  }

  Widget _materiasWidget(BuildContext context, String detalhe) {
    final materias = pessoa['materias'];

    if (materias is! List || materias.isEmpty) {
      return Text(
        detalhe,
        style: const TextStyle(
          color: Color(0xFF64708D),
          fontSize: 12.5,
          height: 1.5,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: materias.map<Widget>((item) {
        if (item is! Map) {
          return const SizedBox.shrink();
        }

        final sigla = (item['sigla'] ?? '').toString();
        final nomeCompleto =
            (item['nomeCompleto'] ?? sigla).toString();

        return Tooltip(
          message: nomeCompleto,
          waitDuration: const Duration(milliseconds: 300),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: Text(sigla),
                    content: Text(nomeCompleto),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text('Fechar'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2,
                vertical: 4,
              ),
              child: Text(
                sigla,
                style: const TextStyle(
                  color: Color(0xFF5368CE),
                  fontSize: 12.5,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dotted,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
