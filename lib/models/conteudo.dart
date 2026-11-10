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
  if (valor is! String || valor.trim().isEmpty) return null;
  return valor;
}

class Secao {
  final String titulo;
  final String texto;
  final String? imagem;
  final String motivoEscolha;
  final String personagem;
  final String motivoPersonagem;
  final String? imagemPersonagem;
  final String objeto;
  final String motivoObjeto;
  final String? imagemObjeto;

  const Secao({
    this.titulo = '',
    this.texto = '',
    this.imagem,
    this.motivoEscolha = '',
    this.personagem = '',
    this.motivoPersonagem = '',
    this.imagemPersonagem,
    this.objeto = '',
    this.motivoObjeto = '',
    this.imagemObjeto,
  });

  factory Secao.fromJson(Map<String, dynamic> j) => Secao(
        titulo: j['titulo'] ?? '',
        texto: j['texto'] ?? '',
        imagem: _imagemOpcional(j['imagem']),
        motivoEscolha: j['motivoEscolha'] ?? '',
        personagem: j['personagem'] ?? '',
        motivoPersonagem: j['motivoPersonagem'] ?? '',
        imagemPersonagem: _imagemOpcional(j['imagemPersonagem']),
        objeto: j['objeto'] ?? '',
        motivoObjeto: j['motivoObjeto'] ?? '',
        imagemObjeto: _imagemOpcional(j['imagemObjeto']),
      );
}

class PaginaSimples {
  final String titulo;
  final String? imagemHeader;
  final List<Secao> secoes;

  // Dados específicos da página de créditos.
  final List<Map<String, dynamic>> professores;
  final List<Map<String, dynamic>> creditosIntegrantes;

  const PaginaSimples({
    required this.titulo,
    this.imagemHeader,
    this.secoes = const [],
    this.professores = const [],
    this.creditosIntegrantes = const [],
  });

  factory PaginaSimples.fromJson(Map<String, dynamic> j) {
    final secoesJson = j['secoes'] is List ? j['secoes'] as List : const [];
    final primeiraSecao = secoesJson.isNotEmpty && secoesJson.first is Map
        ? _mapaSegura(secoesJson.first)
        : const <String, dynamic>{};

    final professores = _listaMapasSegura(
      j['professores'] ?? primeiraSecao['professores'],
    );
    final creditosIntegrantes = _listaMapasSegura(
      j['integrantes'] ?? primeiraSecao['integrantes'],
    );

    return PaginaSimples(
      titulo: j['titulo'] ?? '',
      imagemHeader: j['imagemHeader'] is String ? j['imagemHeader'] as String : null,
      secoes: secoesJson
          .whereType<Map>()
          .map((e) => Secao.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      professores: professores,
      creditosIntegrantes: creditosIntegrantes,
    );
  }
}

class Integrante {
  final String nome;
  final String cargo;
  final String texto;
  final String? foto;

  const Integrante({
    required this.nome,
    required this.cargo,
    required this.texto,
    this.foto,
  });

  factory Integrante.fromJson(Map<String, dynamic> j) => Integrante(
        nome: j['nome'] ?? '',
        cargo: j['cargo'] ?? '',
        texto: j['texto'] ?? '',
        foto: _imagemOpcional(j['foto']),
      );
}

class EquipeDados {
  final String titulo;
  final String? imagemHeader;
  final List<Integrante> integrantes;

  const EquipeDados({
    required this.titulo,
    this.imagemHeader,
    this.integrantes = const [],
  });

  factory EquipeDados.fromJson(Map<String, dynamic> j) => EquipeDados(
        titulo: j['titulo'] ?? '',
        imagemHeader: j['imagemHeader'] is String ? j['imagemHeader'] as String : null,
        integrantes: (j['integrantes'] is List ? j['integrantes'] as List : const [])
            .whereType<Map>()
            .map((e) => Integrante.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
}

class BotaoHome {
  final String rotulo;
  final String icone;
  final String rota;

  const BotaoHome({
    required this.rotulo,
    required this.icone,
    required this.rota,
  });

  factory BotaoHome.fromJson(Map<String, dynamic> j) => BotaoHome(
        rotulo: j['rotulo'] ?? '',
        icone: j['icone'] ?? '',
        rota: j['rota'] ?? '',
      );
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

  factory HomeDados.fromJson(Map<String, dynamic> j) => HomeDados(
        fotos: ((j['fotos'] is List ? j['fotos'] as List : const [])
                .whereType<String>()
                .map((foto) => foto.trim())
                .where((foto) => foto.isNotEmpty)
                .toList()),
        tituloDescubra: j['tituloDescubra'] ?? '',
        botoes: (j['botoes'] is List ? j['botoes'] as List : const [])
            .whereType<Map>()
            .map((e) => BotaoHome.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
}

class Conteudo {
  final String appTitulo;
  final HomeDados home;
  final PaginaSimples empresa;
  final PaginaSimples jogo;
  final EquipeDados equipe;
  final PaginaSimples creditos;

  const Conteudo({
    required this.appTitulo,
    required this.home,
    required this.empresa,
    required this.jogo,
    required this.equipe,
    required this.creditos,
  });

  factory Conteudo.fromJson(Map<String, dynamic> j) => Conteudo(
        appTitulo: _mapaSegura(j['app'])['titulo'] ?? '',
        home: HomeDados.fromJson(_mapaSegura(j['home'])),
        empresa: PaginaSimples.fromJson(_mapaSegura(j['empresa'])),
        jogo: PaginaSimples.fromJson(_mapaSegura(j['jogo'])),
        equipe: EquipeDados.fromJson(_mapaSegura(j['equipe'])),
        creditos: PaginaSimples.fromJson(_mapaSegura(j['creditos'])),
      );
}
