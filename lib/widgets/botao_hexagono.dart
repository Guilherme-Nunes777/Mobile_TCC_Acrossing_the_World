import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Converte o nome do ícone do JSON em IconData.
/// Para criar novos ícones, adicione uma linha aqui e use o nome no JSON.
IconData iconePorNome(String nome) {
  switch (nome) {
    case 'empresa':
      return Icons.apartment;
    case 'jogo':
      return Icons.sports_esports;
    case 'equipe':
      return Icons.groups;
    case 'creditos':
      return Icons.more_horiz;
    default:
      return Icons.help_outline;
  }
}

/// Botão hexagonal (azul por fora, laranja por dentro) com ícone e rótulo
class BotaoHexagono extends StatelessWidget {
  final IconData icone;
  final String rotulo;
  final VoidCallback onTap;

  const BotaoHexagono({
    super.key,
    required this.icone,
    required this.rotulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 100,
            height: 116,
            child: CustomPaint(
              painter: _HexagonoPainter(),
              child: Center(child: Icon(icone, color: Colors.white, size: 48)),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            rotulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _HexagonoPainter extends CustomPainter {
  Path _hex(Size s, double escala) {
    final w = s.width * escala;
    final h = s.height * escala;
    final dx = (s.width - w) / 2;
    final dy = (s.height - h) / 2;
    return Path()
      ..moveTo(dx + w / 2, dy)
      ..lineTo(dx + w, dy + h * 0.25)
      ..lineTo(dx + w, dy + h * 0.75)
      ..lineTo(dx + w / 2, dy + h)
      ..lineTo(dx, dy + h * 0.75)
      ..lineTo(dx, dy + h * 0.25)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(_hex(size, 1.0), Paint()..color = AppColors.azul);
    canvas.drawPath(_hex(size, 0.88), Paint()..color = AppColors.laranja);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
