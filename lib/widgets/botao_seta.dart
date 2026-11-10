
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Botão circular reutilizável com ícone e ação.
class BotaoSeta extends StatelessWidget {
  final IconData icone;
  final VoidCallback onTap;
  final double tamanho;
  final Color? cor;
  final Color? corIcone;
  final String? tooltip;

  const BotaoSeta({
    super.key,
    required this.icone,
    required this.onTap,
    this.tamanho = 48,
    this.cor,
    this.corIcone,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tamanho,
      height: tamanho,
      child: Material(
        color: cor ?? AppColors.azul,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          onPressed: onTap,
          tooltip: tooltip,
          padding: EdgeInsets.zero,
          iconSize: tamanho * 0.65,
          color: corIcone ?? Colors.white,
          icon: Icon(icone),
        ),
      ),
    );
  }
}
