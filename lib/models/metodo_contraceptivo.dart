enum MetodoContraceptivo {
  naoSeAplica,
  nenhum,
  pilula,
  injetavel,
  diu,
  implante,
  adesivo,
  anelVaginal,
  preservativoMasculino,
  preservativoFeminino,
  laqueadura,
  vasectomia,
  outros;

  String get descricao {
    switch (this) {
      case MetodoContraceptivo.naoSeAplica:
        return 'Não se aplica';
      case MetodoContraceptivo.nenhum:
        return 'Nenhum';
      case MetodoContraceptivo.pilula:
        return 'Pílula anticoncepcional';
      case MetodoContraceptivo.injetavel:
        return 'Injetável';
      case MetodoContraceptivo.diu:
        return 'DIU';
      case MetodoContraceptivo.implante:
        return 'Implante';
      case MetodoContraceptivo.adesivo:
        return 'Adesivo';
      case MetodoContraceptivo.anelVaginal:
        return 'Anel vaginal';
      case MetodoContraceptivo.preservativoMasculino:
        return 'Preservativo masculino';
      case MetodoContraceptivo.preservativoFeminino:
        return 'Preservativo feminino';
      case MetodoContraceptivo.laqueadura:
        return 'Laqueadura';
      case MetodoContraceptivo.vasectomia:
        return 'Vasectomia';
      case MetodoContraceptivo.outros:
        return 'Outros';
    }
  }

  static List<MetodoContraceptivo> get valores {
    return MetodoContraceptivo.values;
  }

  static List<String> get descricoes {
    return valores.map((e) => e.descricao).toList();
  }
}

// Extensão para converter string para enum
extension MetodoContraceptivoExtension on MetodoContraceptivo {
  static MetodoContraceptivo fromString(String value) {
    switch (value) {
      case 'naoSeAplica':
        return MetodoContraceptivo.naoSeAplica;
      case 'nenhum':
        return MetodoContraceptivo.nenhum;
      case 'pilula':
        return MetodoContraceptivo.pilula;
      case 'injetavel':
        return MetodoContraceptivo.injetavel;
      case 'diu':
        return MetodoContraceptivo.diu;
      case 'implante':
        return MetodoContraceptivo.implante;
      case 'adesivo':
        return MetodoContraceptivo.adesivo;
      case 'anelVaginal':
        return MetodoContraceptivo.anelVaginal;
      case 'preservativoMasculino':
        return MetodoContraceptivo.preservativoMasculino;
      case 'preservativoFeminino':
        return MetodoContraceptivo.preservativoFeminino;
      case 'laqueadura':
        return MetodoContraceptivo.laqueadura;
      case 'vasectomia':
        return MetodoContraceptivo.vasectomia;
      case 'outros':
        return MetodoContraceptivo.outros;
      default:
        return MetodoContraceptivo.nenhum;
    }
  }
}
