import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_tcc/main.dart';
import 'package:mobile_tcc/services/conteudo_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('As quatro imagens da galeria existem e podem ser decodificadas',
      () async {
    final texto = await rootBundle.loadString('assets/data/conteudo.json');
    final dados = jsonDecode(texto) as Map<String, dynamic>;
    final home = dados['home'] as Map<String, dynamic>;
    final fotos = (home['fotos'] as List).cast<String>();

    expect(fotos, [
      'assets/images/fase_egito.png',
      'assets/images/fase_brasil.png',
      'assets/images/fase_italia.png',
      'assets/images/fase_japao.png',
    ]);

    for (final caminho in fotos) {
      final arquivo = await rootBundle.load(caminho);
      final codec = await ui.instantiateImageCodec(
        arquivo.buffer.asUint8List(),
      );

      try {
        final quadro = await codec.getNextFrame();
        expect(quadro.image.width, 1024, reason: caminho);
        expect(quadro.image.height, 1024, reason: caminho);
        quadro.image.dispose();
      } finally {
        codec.dispose();
      }
    }

    final fases = ((dados['jogo'] as Map<String, dynamic>)['secoes'] as List);
    for (final fase in fases) {
      final imagem = (fase as Map<String, dynamic>)['imagem'] as String;
      expect(fotos, contains(imagem));
    }
  });

  testWidgets('O carrossel renderiza as imagens e permite avançar',
      (tester) async {
    final conteudo = await tester.runAsync(ConteudoService.carregar);
    expect(conteudo, isNotNull);
    await tester.pumpWidget(MeuApp(conteudo: conteudo!));
    await tester.pumpAndSettle();

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('EGITO'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/fase_egito.png',
      ),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.arrow_forward).first);
    await tester.pumpAndSettle();
    expect(find.text('BRASIL'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/fase_brasil.png',
      ),
      findsOneWidget,
    );
  });
}
