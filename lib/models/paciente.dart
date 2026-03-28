import 'visita_domiciliar.dart';

class Paciente {
  int? id;
  String nome;
  DateTime dataNascimento;
  String sexo;
  String cpf;
  String microarea;
  String endereco;
  List<VisitaDomiciliar> visitas;

  Paciente({
    this.id,
    required this.nome,
    required this.dataNascimento,
    required this.sexo,
    required this.cpf,
    required this.microarea,
    required this.endereco,
    this.visitas = const [],
  });

  // Calcula idade baseado na data de nascimento
  int getIdade() {
    final hoje = DateTime.now();
    int idade = hoje.year - dataNascimento.year;
    if (hoje.month < dataNascimento.month ||
        (hoje.month == dataNascimento.month && hoje.day < dataNascimento.day)) {
      idade--;
    }
    return idade;
  }

  // Verificações demográficas
  bool isMenorDeSeis() => getIdade() < 6;

  bool isMulherIdadeFertil() {
    return sexo == 'FEMININO' && getIdade() >= 25 && getIdade() <= 64;
  }

  bool isHomem() => sexo == 'MASCULINO';

  bool isHomemIdadeVasectomia() {
    return isHomem() && getIdade() >= 25 && getIdade() <= 64;
  }

  // Pega a última visita do paciente
  VisitaDomiciliar? getUltimaVisita() {
    if (visitas.isEmpty) return null;
    return visitas.last;
  }

  // Métodos baseados na última visita
  bool isDiabetes() {
    final ultima = getUltimaVisita();
    return ultima != null && ultima.diabetes;
  }

  bool isHipertensao() {
    final ultima = getUltimaVisita();
    return ultima != null && ultima.hipertensao;
  }

  bool isConsultaDiabetesAtrasada() {
    final ultima = getUltimaVisita();
    if (ultima == null || !ultima.diabetes) return false;
    return ultima.isConsultaDiabetesAtrasada();
  }

  bool isConsultaHipertensaoAtrasada() {
    final ultima = getUltimaVisita();
    if (ultima == null || !ultima.hipertensao) return false;
    return ultima.isConsultaHipertensaoAtrasada();
  }

  bool isCadernetaAtrasada() {
    if (!isMenorDeSeis()) return false;
    final ultima = getUltimaVisita();
    if (ultima == null) return false;
    return ultima.isCadernetaAtrasada();
  }

  bool isPreventivoAtrasado() {
    if (!isMulherIdadeFertil()) return false;
    final ultima = getUltimaVisita();
    if (ultima == null) return false;
    return ultima.isPreventivoAtrasado();
  }

  bool isInteresseVasectomia() {
    if (!isHomemIdadeVasectomia()) return false;
    final ultima = getUltimaVisita();
    return ultima != null && ultima.interesseVasectomia;
  }

  bool isAcamado() {
    final ultima = getUltimaVisita();
    return ultima != null && ultima.acamado;
  }

  // Priorização
  bool isPrioritario() {
    return (isDiabetes() && isConsultaDiabetesAtrasada()) ||
        (isHipertensao() && isConsultaHipertensaoAtrasada()) ||
        (isMenorDeSeis() && isCadernetaAtrasada()) ||
        (isMulherIdadeFertil() && isPreventivoAtrasado()) ||
        (isHomemIdadeVasectomia() && isInteresseVasectomia()) ||
        isAcamado();
  }

  String getPrioridadeDescricao() {
    List<String> motivos = [];
    if (isDiabetes() && isConsultaDiabetesAtrasada())
      motivos.add('Diabetico sem consulta');
    if (isHipertensao() && isConsultaHipertensaoAtrasada())
      motivos.add('Hipertenso sem consulta');
    if (isMenorDeSeis() && isCadernetaAtrasada())
      motivos.add('Crianca caderneta atrasada');
    if (isMulherIdadeFertil() && isPreventivoAtrasado())
      motivos.add('Mulher preventivo atrasado');
    if (isHomemIdadeVasectomia() && isInteresseVasectomia())
      motivos.add('Interesse vasectomia');
    if (isAcamado()) motivos.add('Acamado');
    return motivos.join(', ');
  }

  // Conversão para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'data_nascimento': dataNascimento.toIso8601String(),
      'sexo': sexo,
      'cpf': cpf,
      'microarea': microarea,
      'endereco': endereco,
    };
  }

  factory Paciente.fromMap(Map<String, dynamic> map) {
    return Paciente(
      id: map['id'],
      nome: map['nome'],
      dataNascimento: DateTime.parse(map['data_nascimento']),
      sexo: map['sexo'],
      cpf: map['cpf'],
      microarea: map['microarea'],
      endereco: map['endereco'],
    );
  }

  @override
  String toString() {
    return '$nome | ${getIdade()} anos | $microarea | $cpf';
  }
}
