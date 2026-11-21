import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/pdf_download_stub.dart'
    if (dart.library.html) '../services/pdf_download_web.dart' as pdf_download;

import '../models/conteudo.dart';
import '../widgets/header_imagem.dart';
import 'documento_pdf_page.dart';

class CreditosPage extends StatelessWidget {
  final PaginaSimples dados;

  const CreditosPage({
    super.key,
    required this.dados,
  });

  static const cor = Color(0xFF5368CE);
  static const texto = Color(0xFF202B46);
  static const secundario = Color(0xFF64708D);

  Future<void> _abrirUrl(
    BuildContext context,
    String endereco,
  ) async {
    final uri = Uri.tryParse(endereco.trim());

    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
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
            content: Text(
              'Não foi possível abrir o endereço.',
            ),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não foi possível abrir o endereço.',
            ),
          ),
        );
      }
    }
  }

  bool _documentoDisponivel(Map<String, dynamic> documento) {
    final arquivo = (documento['arquivo'] ?? '').toString().trim();
    final url = (documento['url'] ?? '').toString().trim();
    return (arquivo.startsWith('assets/documentation/') &&
            arquivo.toLowerCase().endsWith('.pdf')) ||
        (Uri.tryParse(url)?.hasAbsolutePath == true &&
            (url.startsWith('https://') || url.startsWith('http://')));
  }

  Future<void> _abrirDocumento(
    BuildContext context,
    Map<String, dynamic> documento,
  ) async {
    final arquivo = (documento['arquivo'] ?? '').toString().trim();
    if (arquivo.startsWith('assets/documentation/') &&
        arquivo.toLowerCase().endsWith('.pdf')) {
      if (kIsWeb) {
        try {
          pdf_download.baixarPdfWeb(arquivo, arquivo.split('/').last);
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Não foi possível baixar o PDF.')),
            );
          }
        }
        return;
      }
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => DocumentoPdfPage(
            caminho: arquivo,
            titulo:
                (documento['titulo'] ?? 'Documento final do TCC').toString(),
          ),
        ),
      );
      return;
    }
    await _abrirUrl(context, (documento['url'] ?? '').toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeaderImagem(
                titulo: dados.titulo,
                imagem: dados.imagemHeader,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Titulo(
                      Icons.school_rounded,
                      'Professores orientadores',
                    ),
                    const SizedBox(height: 16),
                    _professores(),
                    if (dados.referencias.isNotEmpty) ...[
                      const SizedBox(height: 30),
                      const _Titulo(
                        Icons.menu_book_rounded,
                        'Referências',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Fontes utilizadas no desenvolvimento do projeto.',
                        style: TextStyle(
                          color: secundario,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (final referencia in dados.referencias)
                        _Recurso(
                          titulo: (referencia['titulo'] ?? '').toString(),
                          descricao: (referencia['descricao'] ?? '').toString(),
                          tipo: 'Referência',
                          icone: Icons.link_rounded,
                          ativo:
                              (referencia['url'] ?? '').toString().isNotEmpty,
                          onTap: () => _abrirUrl(
                            context,
                            (referencia['url'] ?? '').toString(),
                          ),
                        ),
                    ],
                    const SizedBox(height: 26),
                    const _Titulo(
                      Icons.description_rounded,
                      'Documento final do TCC',
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      kIsWeb
                          ? 'Baixe a documentação completa em PDF sem abrir o documento no site.'
                          : 'Consulte a documentação completa do projeto em PDF.',
                      style: TextStyle(
                        color: secundario,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (dados.documentos.isEmpty)
                      const _Recurso(
                        titulo: 'Documento final do TCC',
                        descricao:
                            'Ainda não disponível. O arquivo será adicionado futuramente.',
                        tipo: 'Em breve',
                        icone: Icons.description_outlined,
                        ativo: false,
                      )
                    else
                      for (final documento in dados.documentos)
                        _Recurso(
                          titulo:
                              (documento['titulo'] ?? 'Documento final do TCC')
                                  .toString(),
                          descricao: (documento['descricao'] ?? '').toString(),
                          tipo: (documento['tipo'] ?? 'Documento').toString(),
                          icone: kIsWeb
                              ? Icons.download_rounded
                              : Icons.description_outlined,
                          ativo: _documentoDisponivel(documento),
                          onTap: () => _abrirDocumento(context, documento),
                        ),
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
                            color: cor,
                            size: 28,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Agradecemos a todos que contribuíram para a realização deste projeto!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: secundario,
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

  Widget _professores() {
    if (dados.professores.isEmpty) {
      return const Text(
        'Nenhum professor cadastrado.',
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final colunas = constraints.maxWidth >= 850
            ? 3
            : constraints.maxWidth >= 540
                ? 2
                : 1;

        const espaco = 14.0;

        final largura =
            (constraints.maxWidth - espaco * (colunas - 1)) / colunas;

        return Wrap(
          spacing: espaco,
          runSpacing: espaco,
          children: [
            for (final professor in dados.professores)
              SizedBox(
                width: largura,
                child: _ProfessorCard(
                  professor: professor,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Titulo extends StatelessWidget {
  final IconData icone;
  final String titulo;

  const _Titulo(
    this.icone,
    this.titulo,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: CreditosPage.cor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icone,
            color: CreditosPage.cor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              color: CreditosPage.texto,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _Recurso extends StatelessWidget {
  final String titulo;
  final String descricao;
  final String tipo;
  final IconData icone;
  final bool ativo;
  final VoidCallback? onTap;

  const _Recurso({
    required this.titulo,
    required this.descricao,
    required this.tipo,
    required this.icone,
    required this.ativo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(
          color: Color(0xFFE6EAF3),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: ativo ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icone,
                color: CreditosPage.cor,
                size: 30,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tipo,
                      style: const TextStyle(
                        color: CreditosPage.cor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      titulo,
                      style: const TextStyle(
                        color: CreditosPage.texto,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (descricao.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        descricao,
                        style: const TextStyle(
                          color: CreditosPage.secundario,
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
                ativo ? Icons.open_in_new_rounded : Icons.schedule_rounded,
                color: ativo ? CreditosPage.cor : Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfessorCard extends StatelessWidget {
  final Map<String, dynamic> professor;

  const _ProfessorCard({
    required this.professor,
  });

  @override
  Widget build(BuildContext context) {
    final nome = (professor['nome'] ?? '').toString();
    final foto = (professor['foto'] ?? '').toString();
    final materia = (professor['matéria'] ?? '').toString();
    final materias = professor['materias'];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE6EAF3),
        ),
      ),
      child: Column(
        children: [
          ClipOval(
            child: SizedBox(
              width: 100,
              height: 100,
              child: foto.isEmpty
                  ? const Icon(
                      Icons.school_rounded,
                      size: 46,
                    )
                  : Image.asset(
                      foto,
                      fit: BoxFit.cover,
                      errorBuilder: (_, error, stack) => const Icon(
                        Icons.school_rounded,
                        size: 46,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            nome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CreditosPage.texto,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (materias is List && materias.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: [
                for (final item in materias.whereType<Map>())
                  TextButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: Text(
                            (item['sigla'] ?? '').toString(),
                          ),
                          content: Text(
                            (item['nomeCompleto'] ?? '').toString(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              child: const Text('Fechar'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      (item['sigla'] ?? '').toString(),
                    ),
                  ),
              ],
            )
          else
            Text(
              materia,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CreditosPage.secundario,
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }
}
