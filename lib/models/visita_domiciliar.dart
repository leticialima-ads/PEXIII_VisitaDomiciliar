import 'metodo_contraceptivo.dart';

class VisitaDomiciliar {
  int? id;
  int pacienteId;
  DateTime data;
  String motivo;
  String observacoes;
  bool acamado;

  // Condições de saúde
  bool diabetes;
  DateTime? dataConsultaDiabetes;
  bool hipertensao;
  DateTime? dataConsultaHipertensao;

  // Saúde da mulher
  bool preventivoEmDia;
  DateTime? dataUltimoPreventivo;
  MetodoContraceptivo? metodoContraceptivo;

  // Saúde da criança
  bool cadernetaEmDia;

  // Planejamento familiar
  bool interesseVasectomia;

  VisitaDomiciliar({
    this.id,
    required this.pacienteId,
    required this.data,
    required this.motivo,
    required this.observacoes,
    this.acamado = false,
    this.diabetes = false,
    this.dataConsultaDiabetes,
    this.hipertensao = false,
    this.dataConsultaHipertensao,
    this.preventivoEmDia = true,
    this.dataUltimoPreventivo,
    this.metodoContraceptivo = MetodoContraceptivo.nenhum,
    this.cadernetaEmDia = true,
    this.interesseVasectomia = false,
  });

  // Métodos de atraso
  bool isConsultaDiabetesAtrasada() {
    if (!diabetes || dataConsultaDiabetes == null) return false;
    final diff = DateTime.now().difference(dataConsultaDiabetes!);
    return diff.inDays > 30;
  }

  bool isConsultaHipertensaoAtrasada() {
    if (!hipertensao || dataConsultaHipertensao == null) return false;
    final diff = DateTime.now().difference(dataConsultaHipertensao!);
    return diff.inDays > 30;
  }

  bool isPreventivoAtrasado() {
    if (preventivoEmDia) return false;
    if (dataUltimoPreventivo == null) return true;
    final diff = DateTime.now().difference(dataUltimoPreventivo!);
    return diff.inDays > 365;
  }

  bool isCadernetaAtrasada() {
    return !cadernetaEmDia;
  }

  bool isPrioritario() {
    return (diabetes && isConsultaDiabetesAtrasada()) ||
        (hipertensao && isConsultaHipertensaoAtrasada()) ||
        (!preventivoEmDia && isPreventivoAtrasado()) ||
        (!cadernetaEmDia) ||
        interesseVasectomia;
  }

  String getPrioridadeDescricao() {
    List<String> motivos = [];
    if (diabetes && isConsultaDiabetesAtrasada())
      motivos.add('Diabetico sem consulta');
    if (hipertensao && isConsultaHipertensaoAtrasada())
      motivos.add('Hipertenso sem consulta');
    if (!preventivoEmDia && isPreventivoAtrasado())
      motivos.add('Preventivo atrasado');
    if (!cadernetaEmDia) motivos.add('Caderneta atrasada');
    if (interesseVasectomia) motivos.add('Interesse vasectomia');
    return motivos.join(', ');
  }

  // Conversão para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paciente_id': pacienteId,
      'data': data.toIso8601String(),
      'motivo': motivo,
      'observacoes': observacoes,
      'acamado': acamado ? 1 : 0,
      'diabetes': diabetes ? 1 : 0,
      'data_consulta_diabetes': dataConsultaDiabetes?.toIso8601String(),
      'hipertensao': hipertensao ? 1 : 0,
      'data_consulta_hipertensao': dataConsultaHipertensao?.toIso8601String(),
      'preventivo_em_dia': preventivoEmDia ? 1 : 0,
      'data_ultimo_preventivo': dataUltimoPreventivo?.toIso8601String(),
      'metodo_contraceptivo': metodoContraceptivo?.name,
      'caderneta_em_dia': cadernetaEmDia ? 1 : 0,
      'interesse_vasectomia': interesseVasectomia ? 1 : 0,
    };
  }

  factory VisitaDomiciliar.fromMap(Map<String, dynamic> map) {
    return VisitaDomiciliar(
      id: map['id'],
      pacienteId: map['paciente_id'],
      data: DateTime.parse(map['data']),
      motivo: map['motivo'],
      observacoes: map['observacoes'],
      acamado: map['acamado'] == 1,
      diabetes: map['diabetes'] == 1,
      dataConsultaDiabetes: map['data_consulta_diabetes'] != null
          ? DateTime.parse(map['data_consulta_diabetes'])
          : null,
      hipertensao: map['hipertensao'] == 1,
      dataConsultaHipertensao: map['data_consulta_hipertensao'] != null
          ? DateTime.parse(map['data_consulta_hipertensao'])
          : null,
      preventivoEmDia: map['preventivo_em_dia'] == 1,
      dataUltimoPreventivo: map['data_ultimo_preventivo'] != null
          ? DateTime.parse(map['data_ultimo_preventivo'])
          : null,
      metodoContraceptivo: map['metodo_contraceptivo'] != null
          ? MetodoContraceptivoExtension.fromString(map['metodo_contraceptivo'])
          : MetodoContraceptivo.nenhum,
      cadernetaEmDia: map['caderneta_em_dia'] == 1,
      interesseVasectomia: map['interesse_vasectomia'] == 1,
    );
  }

  @override
  String toString() {
    return '${data.day}/${data.month}/${data.year} - $motivo';
  }
}
