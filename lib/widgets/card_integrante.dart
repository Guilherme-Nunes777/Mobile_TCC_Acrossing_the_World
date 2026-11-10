
import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/conteudo.dart';
import '../theme/app_colors.dart';
import 'imagem_asset.dart';

class CardIntegrante extends StatefulWidget {
  final Integrante integrante;

  const CardIntegrante({
    super.key,
    required this.integrante,
  });

  @override
  State<CardIntegrante> createState() =>
      _CardIntegranteState();
}

class _CardIntegranteState extends State<CardIntegrante>
    with SingleTickerProviderStateMixin {
  bool _expandido = false;

  @override
  Widget build(BuildContext context) {
    final integrante = widget.integrante;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _construirCabecalho(integrante),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              4,
              18,
              0,
            ),
            child: _construirDescricao(integrante.texto),
          ),

          _construirBotao(),
        ],
      ),
    );
  }

  Widget _construirCabecalho(Integrante integrante) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 96,
              height: 108,
              child: ImagemAsset(
                integrante.foto,
                fallback: const _FotoPlaceholder(),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  integrante.nome,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF252525),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.azul.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    integrante.cargo,
                    style: const TextStyle(
                      color: AppColors.azul,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirDescricao(String texto) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: _expandido ? double.infinity : 76,
        ),
        child: Stack(
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: _expandido ? 0 : 3,
                sigmaY: _expandido ? 0 : 3,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  texto,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: Color(0xFF555555),
                  ),
                ),
              ),
            ),

            if (!_expandido)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 36,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0),
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _construirBotao() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 10,
      ),
      child: Center(
        child: IconButton(
          tooltip: _expandido
              ? 'Recolher descrição'
              : 'Ver descrição completa',
          onPressed: () {
            setState(() {
              _expandido = !_expandido;
            });
          },
          style: IconButton.styleFrom(
            backgroundColor: AppColors.azul.withOpacity(0.08),
            foregroundColor: AppColors.azul,
            fixedSize: const Size(44, 44),
          ),
          icon: AnimatedRotation(
            turns: _expandido ? 0.5 : 0,
            duration: const Duration(milliseconds: 250),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

class _FotoPlaceholder extends StatelessWidget {
  const _FotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.vinho,
      alignment: Alignment.center,
      child: const Icon(
        Icons.person_outline_rounded,
        size: 42,
        color: Colors.white,
      ),
    );
  }
}
