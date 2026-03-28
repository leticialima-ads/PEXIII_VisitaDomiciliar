class RegistroPA {
  int? id;
  int visitaId;
  int sistolica;
  int diastolica;
  String observacoes;

  RegistroPA({
    this.id,
    required this.visitaId,
    required this.sistolica,
    required this.diastolica,
    required this.observacoes,
  });

  String get classificacao {
    if (sistolica < 120 && diastolica < 80) return 'Normal';
    if (sistolica >= 120 && sistolica <= 129 && diastolica < 80)
      return 'Elevada';
    if (sistolica >= 130 && sistolica <= 139 ||
        diastolica >= 80 && diastolica <= 89) {
      return 'Hipertensao Estagio 1';
    }
    if (sistolica >= 140 && sistolica <= 159 ||
        diastolica >= 90 && diastolica <= 99) {
      return 'Hipertensao Estagio 2';
    }
    return 'Hipertensao Estagio 3 (Crise)';
  }

  bool isAlta() => sistolica >= 140 || diastolica >= 90;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'visita_id': visitaId,
      'sistolica': sistolica,
      'diastolica': diastolica,
      'observacoes': observacoes,
    };
  }

  factory RegistroPA.fromMap(Map<String, dynamic> map) {
    return RegistroPA(
      id: map['id'],
      visitaId: map['visita_id'],
      sistolica: map['sistolica'],
      diastolica: map['diastolica'],
      observacoes: map['observacoes'],
    );
  }

  @override
  String toString() {
    return '$sistolica/$diastolica mmHg ($classificacao)';
  }
}
