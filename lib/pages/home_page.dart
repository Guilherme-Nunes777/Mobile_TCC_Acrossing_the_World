import 'package:flutter/material.dart';
import '../models/conteudo.dart';
import '../widgets/botao_hexagono.dart';
import '../widgets/botao_seta.dart';
import '../widgets/imagem_asset.dart';
import '../theme/app_colors.dart';
import 'creditos_page.dart';
import 'empresa_page.dart';
import 'equipe_page.dart';
import 'jogo_page.dart';

class HomePage extends StatefulWidget {
  final Conteudo conteudo;

  const HomePage({
    super.key,
    required this.conteudo,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = PageController();
  int _paginaAtual = 0;

  HomeDados get _home => widget.conteudo.home;

  void _ir(int delta) {
    final total = _home.imagens.length;

    if (total == 0) return;

    final destino = (_paginaAtual + delta + total) % total;

    _controller.animateToPage(
      destino,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _abrir(String destino) {
    final c = widget.conteudo;

    final Widget? tela = switch (destino) {
      'empresa' => EmpresaPage(dados: c.empresa),
      'jogo' => JogoPage(dados: c.jogo),
      'equipe' => EquipePage(dados: c.equipe),
      'creditos' => CreditosPage(dados: c.creditos),
      _ => null,
    };

    if (tela != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => tela,
        ),
      );
    }
  }

  List<Widget> _linhasDeBotoes() {
    final botoes = _home.botoes;
    final linhas = <Widget>[];

    for (int i = 0; i < botoes.length; i += 2) {
      final par = botoes.skip(i).take(2).toList();

      linhas.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: i + 2 < botoes.length ? 32 : 0,
          ),
          child: Row(
            children: [
              for (final b in par)
                Expanded(
                  child: Center(
                    child: BotaoHexagono(
                      icone: iconePorNome(b.icone),
                      rotulo: b.titulo,
                      onTap: () => _abrir(b.destino),
                    ),
                  ),
                ),
              if (par.length == 1)
                const Expanded(
                  child: SizedBox(),
                ),
            ],
          ),
        ),
      );
    }

    return linhas;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagens = _home.imagens;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(imagens.length, (i) {
                  final selecionada = i == _paginaAtual;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: selecionada ? 23 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: selecionada
                          ? AppColors.azul
                          : const Color(0xFFB9C5D8),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.13),
                          blurRadius: 22,
                          offset: const Offset(0, 9),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: imagens.length,
                        onPageChanged: (i) => setState(() => _paginaAtual = i),
                        itemBuilder: (_, i) {
                          // Imagens quadradas 1:1: exibir a foto inteira.
                          return ImagemAsset(
                            imagens[i],
                            fit: BoxFit.contain,
                            fallback: Container(
                              color: const Color(0xFFF2F4F7),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                size: 36,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BotaoSeta(
                    icone: Icons.arrow_back,
                    onTap: () => _ir(-1),
                  ),
                  Expanded(
                    child: Text(
                      const [
                        'EGITO',
                        'BRASIL',
                        'ITÁLIA',
                        'JAPÃO'
                      ][_paginaAtual],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  BotaoSeta(
                    icone: Icons.arrow_forward,
                    onTap: () => _ir(1),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _home.tituloDescubra,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ..._linhasDeBotoes(),
            ],
          ),
        ),
      ),
    );
  }
}
