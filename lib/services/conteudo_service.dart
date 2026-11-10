import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/conteudo.dart';

class ConteudoService {
  static const _caminho = 'assets/data/conteudo.json';

  static Future<Conteudo> carregar() async {
    final texto = await rootBundle.loadString(_caminho);
    final json = jsonDecode(texto) as Map<String, dynamic>;
    return Conteudo.fromJson(json);
  }
}
