import 'package:flutter/material.dart';
import 'models/conteudo.dart';
import 'pages/home_page.dart';
import 'services/conteudo_service.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final conteudo = await ConteudoService.carregar();
  runApp(MeuApp(conteudo: conteudo));
}

class MeuApp extends StatelessWidget {
  final Conteudo conteudo;
  const MeuApp({super.key, required this.conteudo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: conteudo.appTitulo,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.fundo,
        // O protótipo usa Open Sans (negrito). Para usar, adicione a fonte
        // nos assets e defina fontFamily aqui.
        // fontFamily: 'OpenSans',
      ),
      // Limita a largura a de um celular (evita esticar/cortar imagens na web)
      builder: (context, child) => ColoredBox(
        color: AppColors.fundo,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: child,
          ),
        ),
      ),
      home: HomePage(conteudo: conteudo),
    );
  }
}
