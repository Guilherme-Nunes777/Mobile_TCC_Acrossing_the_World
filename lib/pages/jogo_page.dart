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
                Text(
                  secao.titulo.isEmpty
                      ? 'FASE $numero'
                      : secao.titulo,
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
                _Texto(
                  texto: secao.motivoEscolha,
                  vazio: 'Adicione aqui a explicação da escolha do cenário.',
                ),
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
                const SizedBox(height: 12),
                Text(
                  secao.personagem.isEmpty
                      ? 'Nome do personagem'
                      : secao.personagem,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: JogoPage.textoEscuro,
                  ),
                ),
                const SizedBox(height: 6),
                _Texto(
                  texto: secao.motivoPersonagem,
                  vazio: 'Adicione a explicação sobre a escolha '
                      'do personagem.',
                ),
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
                const SizedBox(height: 12),
                Text(
                  secao.objeto.isEmpty
                      ? 'Nome do objeto conquistado'
                      : secao.objeto,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: JogoPage.textoEscuro,
                  ),
                ),
                const SizedBox(height: 6),
                _Texto(
                  texto: secao.motivoObjeto,
                  vazio: 'Adicione a explicação sobre o objeto '
                      'e sua importância.',
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
  final String vazio;

  const _Texto({
    required this.texto,
    required this.vazio,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      texto.trim().isEmpty ? vazio : texto,
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
      return AspectRatio(
        aspectRatio: proporcao,
        child: Container(
          width: double.infinity,
          color: const Color(0xFFEDF0F6),
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_outlined,
            size: 42,
            color: Color(0xFF8992A5),
          ),
        ),
      );
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
          return Container(
            color: const Color(0xFFEDF0F6),
            alignment: Alignment.center,
            child: const Icon(
            Icons.image_not_supported_outlined,
            size: 42,
            color: Color(0xFF8992A5),
            ),
          );
        },
      ),
    );
  }
}