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

  /// Converte String salva no banco para enum
  static MetodoContraceptivo fromString(String value) {
    return MetodoContraceptivo.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MetodoContraceptivo.naoSeAplica,
    );
  }

  /// Lista dos enums
  static List<MetodoContraceptivo> get valores {
    return MetodoContraceptivo.values;
  }

  /// Lista das descrições
  static List<String> get descricoes {
    return values.map((e) => e.descricao).toList();
  }
}
