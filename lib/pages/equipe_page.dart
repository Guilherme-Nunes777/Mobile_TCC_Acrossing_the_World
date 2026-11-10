import 'package:flutter/material.dart';

import '../models/conteudo.dart';
import '../widgets/card_integrante.dart';
import '../widgets/header_imagem.dart';

class EquipePage extends StatelessWidget {
  final EquipeDados dados;

  const EquipePage({
    super.key,
    required this.dados,
  });

  @override
  Widget build(BuildContext context) {
    final integrantes = dados.integrantes
        .where(
          (integrante) =>
              integrante.nome.trim().isNotEmpty ||
              integrante.cargo.trim().isNotEmpty,
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderImagem(
              titulo: dados.titulo,
              imagem: dados.imagemHeader,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nossa equipe',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252525),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Conheça as pessoas por trás do projeto.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                24,
              ),
              child: Column(
                children: [
                  for (var i = 0; i < integrantes.length; i++)
                    CardIntegrante(
                      key: ValueKey(
                        '${integrantes[i].nome}-${integrantes[i].cargo}-$i',
                      ),
                      integrante: integrantes[i],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
