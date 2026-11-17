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
  if (valor is! List) return [];

  return valor
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

String? _imagemOpcional(dynamic valor) {
  final imagem = valor?.toString().trim() ?? '';
  return imagem.isEmpty ? null : imagem;
}

class Topico {
  final String titulo;
  final String texto;
  final String? imagem;
  final double proporcaoImagem;

  const Topico({
    required this.titulo,
    required this.texto,
    this.imagem,
    this.proporcaoImagem = 16 / 9,
  });

  factory Topico.fromJson(Map<String, dynamic> json) {
    return Topico(
      titulo: (json['titulo'] ?? '').toString(),
      texto: (json['texto'] ?? '').toString(),
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
  final List<Map<String, dynamic>> referencias;

  const Secao({
    required this.titulo,
    this.texto = '',
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
    this.referencias = const [],
  });

  factory Secao.fromJson(Map<String, dynamic> json) {
    return Secao(
      titulo: (json['titulo'] ?? '').toString(),
      texto: (json['texto'] ?? '').toString(),
      imagem: _imagemOpcional(json['imagem']),
      proporcaoImagem: _proporcaoImagem(json['proporcaoImagem']),
      motivoEscolha: (json['motivoEscolha'] ?? '').toString(),
      personagem: (json['personagem'] ?? '').toString(),
      motivoPersonagem: (json['motivoPersonagem'] ?? '').toString(),
      imagemPersonagem: _imagemOpcional(json['imagemPersonagem']),
      objeto: (json['objeto'] ?? '').toString(),
      motivoObjeto: (json['motivoObjeto'] ?? '').toString(),
      imagemObjeto: _imagemOpcional(json['imagemObjeto']),
      topicos: (json['topicos'] as List? ?? [])
          .whereType<Map>()
          .map(
            (item) => Topico.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
      mecanicas: _listaMapasSegura(json['mecanicas']),
      referencias: _listaMapasSegura(json['referencias']),
    );
  }
}

class PaginaSimples {
  final String titulo;
  final String imagemHeader;
  final List<Secao> secoes;
  final List<Map<String, dynamic>> professores;
  final List<Map<String, dynamic>> creditosIntegrantes;

  final String linkOficialTitulo;
  final String linkOficialUrl;

  final List<Map<String, dynamic>> referencias;
  final List<Map<String, dynamic>> documentos;

  const PaginaSimples({
    required this.titulo,
    required this.imagemHeader,
    this.secoes = const [],
    this.professores = const [],
    this.creditosIntegrantes = const [],
    this.linkOficialTitulo = '',
    this.linkOficialUrl = '',
    this.referencias = const [],
    this.documentos = const [],
  });

  factory PaginaSimples.fromJson(Map<String, dynamic> json) {
    final secoesJson = (json['secoes'] as List? ?? [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    final professores = <Map<String, dynamic>>[];
    final integrantes = <Map<String, dynamic>>[];

    for (final secao in secoesJson) {
      professores.addAll(
        _listaMapasSegura(secao['professores']),
      );

      integrantes.addAll(
        _listaMapasSegura(secao['integrantes']),
      );
    }

    final linkOficial = _mapaSegura(json['linkOficial']);

    return PaginaSimples(
      titulo: (json['titulo'] ?? '').toString(),
      imagemHeader: (json['imagemHeader'] ?? '').toString(),
      secoes: secoesJson.map(Secao.fromJson).toList(),
      professores: professores,
      creditosIntegrantes: integrantes,
      linkOficialTitulo:
          (linkOficial['titulo'] ?? '').toString(),
      linkOficialUrl:
          (linkOficial['url'] ?? '').toString(),
      referencias: _listaMapasSegura(json['referencias']),
      documentos: _listaMapasSegura(json['documentos']),
    );
  }
}

class Integrante {
  final String nome;
  final String cargo;
  final String texto;
  final String foto;

  const Integrante({
    required this.nome,
    required this.cargo,
    this.texto = '',
    required this.foto,
  });

  factory Integrante.fromJson(Map<String, dynamic> json) {
    return Integrante(
      nome: (json['nome'] ?? '').toString(),
      cargo: (json['cargo'] ?? '').toString(),
      texto: (json['texto'] ?? '').toString(),
      foto: (json['foto'] ?? '').toString(),
    );
  }
}

class EquipeDados {
  final String titulo;
  final String imagemHeader;
  final List<Integrante> integrantes;

  const EquipeDados({
    required this.titulo,
    required this.imagemHeader,
    this.integrantes = const [],
  });

  factory EquipeDados.fromJson(Map<String, dynamic> json) {
    final integrantesJson = (json['integrantes'] as List? ?? [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    return EquipeDados(
      titulo: (json['titulo'] ?? '').toString(),
      imagemHeader: (json['imagemHeader'] ?? '').toString(),
      integrantes: integrantesJson.map(Integrante.fromJson).toList(),
    );
  }
}

class BotaoHome {
  final String titulo;
  final String destino;
  final String icone;

  const BotaoHome({
    required this.titulo,
    required this.destino,
    this.icone = '',
  });

  factory BotaoHome.fromJson(Map<String, dynamic> json) {
    return BotaoHome(
      titulo: (json['rotulo'] ?? json['titulo'] ?? '').toString(),
      destino: (json['rota'] ?? json['destino'] ?? '').toString(),
      icone: (json['icone'] ?? '').toString(),
    );
  }
}

class HomeDados {
  final String titulo;
  final String imagemHeader;
  final String tituloDescubra;
  final List<String> imagens;
  final List<BotaoHome> botoes;

  const HomeDados({
    required this.titulo,
    this.imagemHeader = '',
    this.tituloDescubra = '',
    this.imagens = const [],
    this.botoes = const [],
  });

  factory HomeDados.fromJson(Map<String, dynamic> json) {
    final fotosJson = json['fotos'] ?? json['imagens'];

    return HomeDados(
      titulo: (json['titulo'] ?? '').toString(),
      imagemHeader: (json['imagemHeader'] ?? '').toString(),
      tituloDescubra: (json['tituloDescubra'] ?? '').toString(),
      imagens: (fotosJson as List? ?? [])
          .map((item) => item.toString())
          .toList(),
      botoes: (json['botoes'] as List? ?? [])
          .whereType<Map>()
          .map(
            (item) => BotaoHome.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
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

  const Conteudo({
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
