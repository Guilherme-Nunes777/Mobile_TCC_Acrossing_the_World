Map<String, dynamic> _mapaSegura(dynamic valor) {
  if (valor is Map) {
    return Map<String, dynamic>.from(valor);
  }

  return const <String, dynamic>{};
}

List<Map<String, dynamic>> _listaMapasSegura(dynamic valor) {
  if (valor is! List) return const [];

  return valor
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

String? _imagemOpcional(dynamic valor) {
  if (valor is! String || valor.trim().isEmpty) {
    return null;
  }

  return valor;
}

double _proporcaoImagem(dynamic valor) {
  if (valor is num && valor > 0) {
    return valor.toDouble();
  }

  return 16 / 9;
}

class Topico {
  final String titulo;
  final String texto;
  final String? imagem;
  final double proporcaoImagem;

  const Topico({
    this.titulo = '',
    this.texto = '',
    this.imagem,
    this.proporcaoImagem = 16 / 9,
  });

  factory Topico.fromJson(Map<String, dynamic> j) {
    return Topico(
      titulo: j['titulo']?.toString() ?? '',
      texto: j['texto']?.toString() ?? '',
      imagem: _imagemOpcional(j['imagem']),
      proporcaoImagem: _proporcaoImagem(j['proporcaoImagem']),
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

  // Mecânicas específicas de cada fase
  final List<Map<String, dynamic>> mecanicas;

  const Secao({
    this.titulo = '',
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
  });

  factory Secao.fromJson(Map<String, dynamic> j) {
    return Secao(
      titulo: j['titulo']?.toString() ?? '',
      texto: j['texto']?.toString() ?? '',
      imagem: _imagemOpcional(j['imagem']),
      proporcaoImagem: _proporcaoImagem(j['proporcaoImagem']),

      motivoEscolha: j['motivoEscolha']?.toString() ?? '',

      personagem: j['personagem']?.toString() ?? '',
      motivoPersonagem: j['motivoPersonagem']?.toString() ?? '',
      imagemPersonagem: _imagemOpcional(j['imagemPersonagem']),

      objeto: j['objeto']?.toString() ?? '',
      motivoObjeto: j['motivoObjeto']?.toString() ?? '',
      imagemObjeto: _imagemOpcional(j['imagemObjeto']),

      topicos: _listaMapasSegura(j['topicos'])
          .map((item) => Topico.fromJson(item))
          .toList(),

      mecanicas: _listaMapasSegura(j['mecanicas']),
    );
  }
}

class PaginaSimples {
  final String titulo;
  final String? imagemHeader;
  final List<Secao> secoes;
  final List<Map<String, dynamic>> professores;
  final List<Map<String, dynamic>> creditosIntegrantes;

  const PaginaSimples({
    this.titulo = '',
    this.imagemHeader,
    this.secoes = const [],
    this.professores = const [],
    this.creditosIntegrantes = const [],
  });

  factory PaginaSimples.fromJson(Map<String, dynamic> j) {
    final secoesJson = _listaMapasSegura(j['secoes']);

    final primeiraSecao = secoesJson.isNotEmpty
        ? secoesJson.first
        : <String, dynamic>{};

    return PaginaSimples(
      titulo: j['titulo']?.toString() ?? '',
      imagemHeader: _imagemOpcional(j['imagemHeader']),

      secoes: secoesJson
          .map((item) => Secao.fromJson(item))
          .toList(),

      professores: _listaMapasSegura(
        j['professores'] ?? primeiraSecao['professores'],
      ),

      creditosIntegrantes: _listaMapasSegura(
        j['creditosIntegrantes'] ??
            primeiraSecao['creditosIntegrantes'],
      ),
    );
  }
}

class Integrante {
  final String nome;
  final String cargo;
  final String area;
  final String texto;
  final String? foto;

  const Integrante({
    this.nome = '',
    this.cargo = '',
    this.area = 'JOGOS',
    this.texto = '',
    this.foto,
  });

  factory Integrante.fromJson(Map<String, dynamic> j) {
    return Integrante(
      nome: j['nome']?.toString() ?? '',
      cargo: j['cargo']?.toString() ?? '',
      area: j['area']?.toString() ?? 'JOGOS',
      texto: j['texto']?.toString() ?? '',
      foto: _imagemOpcional(j['foto']),
    );
  }
}

class EquipeDados {
  final String titulo;
  final String? imagemHeader;
  final List<Integrante> integrantes;

  const EquipeDados({
    this.titulo = '',
    this.imagemHeader,
    this.integrantes = const [],
  });

  // Integrantes de Jogos
  List<Integrante> get integrantesJogos {
    return integrantes
        .where(
          (integrante) =>
              integrante.area.trim().toUpperCase() == 'JOGOS',
        )
        .toList();
  }

  // Integrantes de Desenvolvimento de Sistemas
  List<Integrante> get integrantesDS {
    return integrantes
        .where(
          (integrante) =>
              integrante.area.trim().toUpperCase() == 'DS',
        )
        .toList();
  }

  factory EquipeDados.fromJson(Map<String, dynamic> j) {
    return EquipeDados(
      titulo: j['titulo']?.toString() ?? '',
      imagemHeader: _imagemOpcional(j['imagemHeader']),

      integrantes: _listaMapasSegura(j['integrantes'])
          .map((item) => Integrante.fromJson(item))
          .toList(),
    );
  }
}

class BotaoHome {
  final String rotulo;
  final String icone;
  final String rota;

  const BotaoHome({
    this.rotulo = '',
    this.icone = '',
    this.rota = '',
  });

  factory BotaoHome.fromJson(Map<String, dynamic> j) {
    return BotaoHome(
      rotulo: j['rotulo']?.toString() ?? '',
      icone: j['icone']?.toString() ?? '',
      rota: j['rota']?.toString() ?? '',
    );
  }
}

class HomeDados {
  final List<String> fotos;
  final String tituloDescubra;
  final List<BotaoHome> botoes;

  const HomeDados({
    this.fotos = const [],
    this.tituloDescubra = '',
    this.botoes = const [],
  });

  factory HomeDados.fromJson(Map<String, dynamic> j) {
    return HomeDados(
      fotos: (j['fotos'] as List? ?? [])
          .whereType<String>()
          .toList(),

      tituloDescubra:
          j['tituloDescubra']?.toString() ?? '',

      botoes: _listaMapasSegura(j['botoes'])
          .map((item) => BotaoHome.fromJson(item))
          .toList(),
    );
  }
}

class Conteudo {
  final String appTitulo;
  final HomeDados home;
  final PaginaSimples empresa;
  final PaginaSimples jogo;
  final EquipeDados equipe;
  final PaginaSimples creditos;

  const Conteudo({
    this.appTitulo = '',
    this.home = const HomeDados(),
    this.empresa = const PaginaSimples(),
    this.jogo = const PaginaSimples(),
    this.equipe = const EquipeDados(),
    this.creditos = const PaginaSimples(),
  });

  factory Conteudo.fromJson(Map<String, dynamic> j) {
    final app = _mapaSegura(j['app']);

    return Conteudo(
      appTitulo: app['titulo']?.toString() ?? '',

      home: HomeDados.fromJson(
        _mapaSegura(j['home']),
      ),

      empresa: PaginaSimples.fromJson(
        _mapaSegura(j['empresa']),
      ),

      jogo: PaginaSimples.fromJson(
        _mapaSegura(j['jogo']),
      ),

      equipe: EquipeDados.fromJson(
        _mapaSegura(j['equipe']),
      ),

      creditos: PaginaSimples.fromJson(
        _mapaSegura(j['creditos']),
      ),
    );
  }
}
