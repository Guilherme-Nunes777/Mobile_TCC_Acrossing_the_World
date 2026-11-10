import 'package:flutter/material.dart';
import '../models/conteudo.dart';
import '../widgets/header_imagem.dart';

class CreditosPage extends StatelessWidget {
  final PaginaSimples dados;

  const CreditosPage({
    super.key,
    required this.dados,
  });

  @override
  Widget build(BuildContext context) {
    final professores = dados.professores;
    final integrantes = dados.creditosIntegrantes;

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
                    _gradePessoas(
                      professores,
                      professor: true,
                    ),
                    const SizedBox(height: 34),
                    _tituloSecao(
                      Icons.groups_rounded,
                      'Integrantes do grupo',
                    ),
                    const SizedBox(height: 16),
                    _gradePessoas(
                      integrantes,
                      professor: false,
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

  Widget _gradePessoas(
    List<Map<String, dynamic>> pessoas, {
    required bool professor,
  }) {
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
              child: _PessoaCard(
                pessoa: pessoa,
                professor: professor,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _PessoaCard extends StatelessWidget {
  final Map<String, dynamic> pessoa;
  final bool professor;

  const _PessoaCard({
    required this.pessoa,
    required this.professor,
  });

  @override
  Widget build(BuildContext context) {
    final nome = (pessoa['nome'] ?? '').toString();
    final foto = (pessoa['foto'] ?? '').toString();

    final detalhe = professor
        ? (pessoa['matéria'] ?? '').toString()
        : (pessoa['cargo'] ?? '').toString();

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
                        errorBuilder: (_, __, ___) {
                          return _fotoAlternativa();
                        },
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
          if (professor)
            _materiasWidget(context, detalhe)
          else
            Text(
              detalhe,
              style: const TextStyle(
                color: Color(0xFF64708D),
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }

  Widget _fotoAlternativa() {
    return Container(
      color: const Color(0xFFEDF0F6),
      alignment: Alignment.center,
      child: Icon(
        professor
            ? Icons.school_rounded
            : Icons.person_rounded,
        size: 42,
        color: const Color(0xFF5368CE),
      ),
    );
  }

  Widget _materiasWidget(
    BuildContext context,
    String detalhe,
  ) {
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
