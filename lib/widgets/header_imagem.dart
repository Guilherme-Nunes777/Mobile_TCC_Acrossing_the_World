import 'package:flutter/material.dart';
import 'botao_seta.dart';
import 'imagem_asset.dart';
import 'texto_contorno.dart';

/// Cabeçalho com imagem de fundo, botão voltar e título com contorno.
/// A altura acompanha a proporção da imagem ([proporcao] = largura / altura),
/// assim a foto aparece inteira, sem cortar topo ou base.
class HeaderImagem extends StatelessWidget {
  final String titulo;
  final String? imagem;
  final bool voltarAbaixoDoTitulo; // na tela Empresa o botão fica embaixo do título
  final double proporcao;

  const HeaderImagem({
    super.key,
    required this.titulo,
    this.imagem,
    this.voltarAbaixoDoTitulo = false,
    this.proporcao = 1080 / 939, // tamanho das imagens header_*.png
  });

  @override
  Widget build(BuildContext context) {
    final topo = MediaQuery.of(context).padding.top;
    final botaoVoltar = BotaoSeta(
      icone: Icons.arrow_back,
      onTap: () => Navigator.of(context).pop(),
    );
    final tituloW = TextoContorno(titulo);

    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: proporcao,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ImagemAsset(imagem),
            Padding(
              padding: EdgeInsets.only(left: 24, right: 24, bottom: 24, top: topo + 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: voltarAbaixoDoTitulo
                    ? [tituloW, const SizedBox(height: 8), botaoVoltar]
                    : [botaoVoltar, const SizedBox(height: 8), tituloW],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
