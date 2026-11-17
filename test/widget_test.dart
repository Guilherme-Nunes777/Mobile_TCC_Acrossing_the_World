import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_tcc/main.dart';
import 'package:mobile_tcc/models/conteudo.dart';

void main() {
  testWidgets(
    'aplicativo exibe a tela inicial',
    (WidgetTester tester) async {
      const conteudo = Conteudo(
        app: {
          'titulo': 'Mobile TCC',
        },
        home: HomeDados(
          titulo: 'HOME',
          tituloDescubra: 'DESCUBRA MAIS:',
        ),
        empresa: PaginaSimples(
          titulo: 'EMPRESA',
          imagemHeader: '',
        ),
        jogo: PaginaSimples(
          titulo: 'JOGO',
          imagemHeader: '',
        ),
        equipe: EquipeDados(
          titulo: 'EQUIPE',
          imagemHeader: '',
        ),
        creditos: PaginaSimples(
          titulo: 'CRÉDITOS',
          imagemHeader: '',
        ),
      );

      await tester.pumpWidget(
        const MeuApp(conteudo: conteudo),
      );

      expect(
        find.text('DESCUBRA MAIS:'),
        findsOneWidget,
      );
    },
  );
}
