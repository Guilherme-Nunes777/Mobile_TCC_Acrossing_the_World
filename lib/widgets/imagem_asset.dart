import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ImagemAsset extends StatelessWidget {
  final String? caminho;
  final BoxFit fit;
  final Widget? fallback;

  const ImagemAsset(this.caminho, {super.key, this.fit = BoxFit.cover, this.fallback});

  @override
  Widget build(BuildContext context) {
    final alt = fallback ?? Container(color: AppColors.cinza);
    if (caminho == null || caminho!.isEmpty) return alt;
    return Image.asset(
      caminho!,
      fit: fit,
      errorBuilder: (_, __, ___) => alt,
    );
  }
}
