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

  const MeuApp({
    super.key,
    required this.conteudo,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: conteudo.app['titulo']?.toString() ?? 'Mobile TCC',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.fundo,
      ),
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
