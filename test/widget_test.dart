// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_tcc/main.dart';
import 'package:mobile_tcc/models/conteudo.dart';

void main() {
  testWidgets('aplicativo exibe a tela inicial', (WidgetTester tester) async {
    const conteudo = Conteudo(
      appTitulo: 'Mobile TCC',
      home: HomeDados(tituloDescubra: 'DESCUBRA MAIS:'),
      empresa: PaginaSimples(titulo: 'EMPRESA'),
      jogo: PaginaSimples(titulo: 'JOGO'),
      equipe: EquipeDados(titulo: 'EQUIPE'),
      creditos: PaginaSimples(titulo: 'CRÉDITOS'),
    );

    await tester.pumpWidget(const MeuApp(conteudo: conteudo));

    expect(find.text('DESCUBRA MAIS:'), findsOneWidget);
  });
}
