double _proporcaoImagem(dynamic valor) {
  if (valor is num && valor > 0) {
    return valor.toDouble();
  }
  return 16 / 9;
}

Map<String, dynamic> _mapaSegura(dynamic valor) {
  if (valor is Map) {
    return Map<String, dynamic>.from(valor);
  }
  return {};
}

List<Map<String, dynamic>> _listaMapasSegura(dynamic valor) {
  if (valor is! List) {
    return [];
  }

  return valor
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

String? _imagemOpcional(dynamic valor) {
  if (valor == null || valor.toString().trim().isEmpty) {
    return null;
  }
  return valor.toString();
}

class Topico {
  final String titulo;
  final String texto;
  final String? imagem;
  final double proporcaoImagem;

  Topico({
    required this.titulo,
    required this.texto,
    this.imagem,
    this.proporcaoImagem = 16 / 9,
  });

  factory Topico.fromJson(Map<String, dynamic> json) {
    return Topico(
      titulo: json['titulo']?.toString() ?? '',
      texto: json['texto']?.toString() ?? '',
      imagem: _imagemOpcional(json['imagem']),
      proporcaoImagem: _proporcaoImagem(json['proporcaoImagem']),
    );
  }
}

class Secao {
  final String titulo;
  final String texto;
  final String? imagem;
  final double proporcaoImagem;
  final String motivoEscolha;
  final String personagem;
  final String motivoPersonagem;
  final String? imagemPersonagem;
  final String objeto;
  final String motivoObjeto;
  final String? imagemObjeto;
  final List<Topico> topicos;
  final List<Map<String, dynamic>> mecanicas;

  Secao({
    required this.titulo,
    required this.texto,
    this.imagem,
    this.proporcaoImagem = 16 / 9,
    this.motivoEscolha = '',
    this.personagem = '',
    this.motivoPersonagem = '',
    this.imagemPersonagem,
    this.objeto = '',
    this.motivoObjeto = '',
    this.imagemObjeto,
    this.topicos = const [],
    this.mecanicas = const [],
  });

  factory Secao.fromJson(Map<String, dynamic> json) {
    return Secao(
      titulo: json['titulo']?.toString() ?? '',
      texto: json['texto']?.toString() ?? '',
      imagem: _imagemOpcional(json['imagem']),
      proporcaoImagem: _proporcaoImagem(json['proporcaoImagem']),
      motivoEscolha: json['motivoEscolha']?.toString() ?? '',
      personagem: json['personagem']?.toString() ?? '',
      motivoPersonagem: json['motivoPersonagem']?.toString() ?? '',
      imagemPersonagem: _imagemOpcional(json['imagemPersonagem']),
      objeto: json['objeto']?.toString() ?? '',
      motivoObjeto: json['motivoObjeto']?.toString() ?? '',
      imagemObjeto: _imagemOpcional(json['imagemObjeto']),
      topicos: _listaMapasSegura(json['topicos'])
          .map((item) => Topico.fromJson(item))
          .toList(),
      mecanicas: _listaMapasSegura(json['mecanicas']),
    );
  }
}

class PaginaSimples {
  final String titulo;
  final String imagemHeader;
  final List<Secao> secoes;
  final List<Map<String, dynamic>> professores;
  final List<Map<String, dynamic>> creditosIntegrantes;

  PaginaSimples({
    required this.titulo,
    required this.imagemHeader,
    required this.secoes,
    this.professores = const [],
    this.creditosIntegrantes = const [],
  });

  factory PaginaSimples.fromJson(Map<String, dynamic> json) {
    final secoesJson = _listaMapasSegura(json['secoes']);

    final professoresJson = <Map<String, dynamic>>[];
    final integrantesJson = <Map<String, dynamic>>[];

    for (final secao in secoesJson) {
      professoresJson.addAll(
        _listaMapasSegura(secao['professores']),
      );

      integrantesJson.addAll(
        _listaMapasSegura(secao['integrantes']),
      );
    }

    return PaginaSimples(
      titulo: json['titulo']?.toString() ?? '',
      imagemHeader: json['imagemHeader']?.toString() ?? '',
      secoes: secoesJson
          .map((item) => Secao.fromJson(item))
          .toList(),
      professores: professoresJson,
      creditosIntegrantes: integrantesJson,
    );
  }
}

class Integrante {
  final String nome;
  final String cargo;
  final String texto;
  final String? foto;

  Integrante({
    required this.nome,
    required this.cargo,
    this.texto = '',
    this.foto,
  });

  factory Integrante.fromJson(Map<String, dynamic> json) {
    return Integrante(
      nome: json['nome']?.toString() ?? '',
      cargo: json['cargo']?.toString() ?? '',
      texto: json['texto']?.toString() ?? '',
      foto: _imagemOpcional(json['foto']),
    );
  }
}

class EquipeDados {
  final String titulo;
  final String imagemHeader;
  final List<Integrante> integrantes;

  EquipeDados({
    required this.titulo,
    required this.imagemHeader,
    required this.integrantes,
  });

  factory EquipeDados.fromJson(Map<String, dynamic> json) {
    final integrantesJson = _listaMapasSegura(json['integrantes']);

    return EquipeDados(
      titulo: json['titulo']?.toString() ?? '',
      imagemHeader: json['imagemHeader']?.toString() ?? '',
      integrantes: integrantesJson
          .map((item) => Integrante.fromJson(item))
          .toList(),
    );
  }
}

class BotaoHome {
  final String titulo;
  final String destino;

  BotaoHome({
    required this.titulo,
    required this.destino,
  });

  factory BotaoHome.fromJson(Map<String, dynamic> json) {
    return BotaoHome(
      titulo: json['titulo']?.toString() ?? '',
      destino: json['destino']?.toString() ?? '',
    );
  }
}

class HomeDados {
  final String titulo;
  final String? imagemHeader;
  final String tituloDescubra;
  final List<String> imagens;
  final List<BotaoHome> botoes;

  HomeDados({
    required this.titulo,
    this.imagemHeader,
    required this.tituloDescubra,
    required this.imagens,
    required this.botoes,
  });

  factory HomeDados.fromJson(Map<String, dynamic> json) {
    final imagensJson = json['imagens'];
    final botoesJson = json['botoes'];

    return HomeDados(
      titulo: json['titulo']?.toString() ?? '',
      imagemHeader: _imagemOpcional(json['imagemHeader']),
      tituloDescubra: json['tituloDescubra']?.toString() ?? '',
      imagens: imagensJson is List
          ? imagensJson.map((item) => item.toString()).toList()
          : [],
      botoes: _listaMapasSegura(botoesJson)
          .map((item) => BotaoHome.fromJson(item))
          .toList(),
    );
  }
}

class Conteudo {
  final Map<String, dynamic> app;
  final HomeDados home;
  final PaginaSimples empresa;
  final PaginaSimples jogo;
  final EquipeDados equipe;
  final PaginaSimples creditos;

  Conteudo({
    required this.app,
    required this.home,
    required this.empresa,
    required this.jogo,
    required this.equipe,
    required this.creditos,
  });

  factory Conteudo.fromJson(Map<String, dynamic> json) {
    return Conteudo(
      app: _mapaSegura(json['app']),
      home: HomeDados.fromJson(
        _mapaSegura(json['home']),
      ),
      empresa: PaginaSimples.fromJson(
        _mapaSegura(json['empresa']),
      ),
      jogo: PaginaSimples.fromJson(
        _mapaSegura(json['jogo']),
      ),
      equipe: EquipeDados.fromJson(
        _mapaSegura(json['equipe']),
      ),
      creditos: PaginaSimples.fromJson(
        _mapaSegura(json['creditos']),
      ),
    );
  }
}