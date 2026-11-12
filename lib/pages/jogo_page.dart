import 'package:flutter/material.dart';

import '../models/conteudo.dart';
import '../widgets/header_imagem.dart';

class JogoPage extends StatelessWidget {
  final PaginaSimples dados;

  const JogoPage({
    super.key,
    required this.dados,
  });

  static const Color azul = Color(0xFF4263A6);
  static const Color fundo = Color(0xFFF5F6FA);
  static const Color textoEscuro = Color(0xFF252B3A);
  static const Color textoClaro = Color(0xFF555B68);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderImagem(
              titulo: dados.titulo,
              imagem: dados.imagemHeader,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CONHEÇA O JOGO',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: textoEscuro,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Conheça os cenários, os personagens e os objetos '
                    'de cada fase.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: textoClaro,
                    ),
                  ),
                  const SizedBox(height: 22),
                  for (int i = 0; i < dados.secoes.length; i++)
                    _CardFase(
                      secao: dados.secoes[i],
                      numero: i + 1,
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

class _CardFase extends StatelessWidget {
  final Secao secao;
  final int numero;

  const _CardFase({
    required this.secao,
    required this.numero,
  });

  void _abrirMecanicas(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(22, 24, 22, 12),
          contentPadding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          title: Row(
            children: [
              const Icon(
                Icons.sports_esports_outlined,
                color: JogoPage.azul,
                size: 25,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'MECÂNICAS — ${secao.titulo}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: JogoPage.textoEscuro,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: secao.mecanicas
                    .where((mecanica) {
                      final titulo =
                          mecanica['titulo']?.toString() ?? '';
                      final descricao =
                          mecanica['descricao']?.toString() ?? '';

                      return titulo.trim().isNotEmpty ||
                          descricao.trim().isNotEmpty;
                    })
                    .map((mecanica) {
                      final titulo =
                          mecanica['titulo']?.toString() ?? '';
                      final descricao =
                          mecanica['descricao']?.toString() ?? '';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (titulo.trim().isNotEmpty)
                              Text(
                                titulo,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: JogoPage.azul,
                                ),
                              ),
                            if (titulo.trim().isNotEmpty &&
                                descricao.trim().isNotEmpty)
                              const SizedBox(height: 7),
                            if (descricao.trim().isNotEmpty)
                              Text(
                                descricao,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.7,
                                  color: JogoPage.textoClaro,
                                ),
                              ),
                          ],
                        ),
                      );
                    })
                    .toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'FECHAR',
                style: TextStyle(
                  color: JogoPage.azul,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Imagem(
            caminho: secao.imagem,
            proporcao: 16 / 9,
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (secao.titulo.trim().isNotEmpty)
                  Text(
                    secao.titulo,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: JogoPage.textoEscuro,
                    ),
                  ),

                const SizedBox(height: 22),

                const _TituloSecao(
                  icone: Icons.landscape_outlined,
                  titulo: 'Por que escolhemos esse cenário?',
                ),
                const SizedBox(height: 8),

                if (secao.motivoEscolha.trim().isNotEmpty)
                  _Texto(texto: secao.motivoEscolha),

                const SizedBox(height: 22),
                const Divider(color: Color(0xFFE2E5EC)),
                const SizedBox(height: 18),

                const _TituloSecao(
                  icone: Icons.person_outline,
                  titulo: 'O personagem',
                ),
                const SizedBox(height: 14),

                _Imagem(
                  caminho: secao.imagemPersonagem,
                  proporcao: 4 / 3,
                ),

                if (secao.personagem.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    secao.personagem,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: JogoPage.textoEscuro,
                    ),
                  ),
                ],

                if (secao.motivoPersonagem.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _Texto(texto: secao.motivoPersonagem),
                ],

                const SizedBox(height: 22),
                const Divider(color: Color(0xFFE2E5EC)),
                const SizedBox(height: 18),

                const _TituloSecao(
                  icone: Icons.workspace_premium_outlined,
                  titulo: 'O objeto conquistado',
                ),
                const SizedBox(height: 14),

                _Imagem(
                  caminho: secao.imagemObjeto,
                  proporcao: 4 / 3,
                ),

                if (secao.objeto.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    secao.objeto,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: JogoPage.textoEscuro,
                    ),
                  ),
                ],

                if (secao.motivoObjeto.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _Texto(texto: secao.motivoObjeto),
                ],

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _abrirMecanicas(context),
                    icon: const Icon(Icons.menu_book_outlined),
                    label: const Text(
                      'CONHECER AS MECÂNICAS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: JogoPage.azul,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 12,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TituloSecao extends StatelessWidget {
  final IconData icone;
  final String titulo;

  const _TituloSecao({
    required this.icone,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icone,
          color: JogoPage.azul,
          size: 22,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: JogoPage.textoEscuro,
            ),
          ),
        ),
      ],
    );
  }
}

class _Texto extends StatelessWidget {
  final String texto;

  const _Texto({
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 14,
        height: 1.7,
        color: JogoPage.textoClaro,
      ),
    );
  }
}

class _Imagem extends StatelessWidget {
  final String? caminho;
  final double proporcao;

  const _Imagem({
    required this.caminho,
    required this.proporcao,
  });

  @override
  Widget build(BuildContext context) {
    if (caminho == null || caminho!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: 350,
      child: Image.asset(
        caminho!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox.shrink();
        },
      ),
    );
  }
}