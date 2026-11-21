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

  List<Secao> _ordenarFases() {
    const ordem = [
      'EGITO',
      'BRASIL',
      'ITÁLIA',
      'JAPÃO',
    ];

    final fases = List<Secao>.from(dados.secoes);

    fases.sort((a, b) {
      final indiceA = ordem.indexOf(a.titulo.trim().toUpperCase());
      final indiceB = ordem.indexOf(b.titulo.trim().toUpperCase());

      if (indiceA == -1 && indiceB == -1) return 0;
      if (indiceA == -1) return 1;
      if (indiceB == -1) return -1;

      return indiceA.compareTo(indiceB);
    });

    return fases;
  }

  @override
  Widget build(BuildContext context) {
    final fases = _ordenarFases();

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
                  for (int i = 0; i < fases.length; i++)
                    _CardFase(
                      secao: fases[i],
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

  Color get _corDaFase {
    switch (secao.titulo.trim().toUpperCase()) {
      case 'EGITO':
        return const Color(0xFFA77C27);
      case 'BRASIL':
        return const Color(0xFF21855B);
      case 'ITÁLIA':
        return const Color(0xFFB85B42);
      case 'JAPÃO':
        return const Color(0xFFB34553);
      default:
        return JogoPage.azul;
    }
  }

  IconData _iconeDaMecanica(String tipo) {
    switch (tipo) {
      case 'explorar':
        return Icons.explore_outlined;
      case 'dialogo':
        return Icons.chat_bubble_outline;
      case 'porta':
        return Icons.door_front_door_outlined;
      case 'historia':
        return Icons.auto_stories_outlined;
      case 'premio':
        return Icons.workspace_premium_outlined;
      case 'saida':
        return Icons.exit_to_app_outlined;
      case 'tempo':
        return Icons.timer_outlined;
      case 'pizza':
        return Icons.local_pizza_outlined;
      case 'forno':
        return Icons.local_fire_department_outlined;
      case 'corte':
        return Icons.content_cut_outlined;
      case 'avaliacao':
        return Icons.star_half_rounded;
      case 'desafio':
        return Icons.sports_soccer_outlined;
      case 'repetir':
        return Icons.replay_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }

  Widget _cartaoMecanica(
    Map<String, dynamic> mecanica,
    int indice,
    Color cor,
  ) {
    final titulo = (mecanica['titulo'] ?? '').toString().trim();
    final descricao = (mecanica['descricao'] ?? '').toString().trim();
    final destaque = (mecanica['destaque'] ?? '').toString().trim();
    final icone = (mecanica['icone'] ?? '').toString().trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E6ED)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: cor.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_iconeDaMecanica(icone), color: cor, size: 23),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (titulo.isNotEmpty)
                  Text(
                    '${indice + 1}. $titulo',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      height: 1.3,
                      color: JogoPage.textoEscuro,
                    ),
                  ),
                if (titulo.isNotEmpty && descricao.isNotEmpty)
                  const SizedBox(height: 7),
                if (descricao.isNotEmpty)
                  Text(
                    descricao,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: JogoPage.textoClaro,
                    ),
                  ),
                if (destaque.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cor.withAlpha(18),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      destaque,
                      style: TextStyle(
                        color: cor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _abrirMecanicas(BuildContext context) {
    final mecanicas = secao.mecanicas.where((mecanica) {
      final titulo = (mecanica['titulo'] ?? '').toString().trim();
      final descricao = (mecanica['descricao'] ?? '').toString().trim();
      return titulo.isNotEmpty || descricao.isNotEmpty;
    }).toList();
    final cor = _corDaFase;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: JogoPage.fundo,
          surfaceTintColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
          contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.sports_esports_outlined,
                    color: cor,
                    size: 26,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'MECÂNICAS — ${secao.titulo}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: JogoPage.textoEscuro,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              const Text(
                'Conheça a aventura passo a passo e descubra como conquistar a recompensa da fase.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: JogoPage.textoClaro,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${mecanicas.length} etapas da fase',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: cor,
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 560,
              maxHeight:
                  MediaQuery.of(dialogContext).size.height * 0.56,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < mecanicas.length; i++)
                    _cartaoMecanica(
                      mecanicas[i],
                      i,
                      cor,
                    ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: cor.withAlpha(22),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          color: cor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'RECOMPENSA DA FASE',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: cor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                secao.objeto,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: JogoPage.textoEscuro,
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
          actions: [
            TextButton.icon(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(),
              icon: const Icon(
                Icons.close_rounded,
                size: 18,
              ),
              label: const Text(
                'FECHAR',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: cor,
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
            color: Colors.black.withValues(alpha: 0.05),
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
                    icon: const Icon(
                      Icons.menu_book_outlined,
                    ),
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
