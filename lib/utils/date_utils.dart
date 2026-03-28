import 'package:intl/intl.dart';

class DateUtilsHelper {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _dateFormatISO = DateFormat('yyyy-MM-dd');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _monthYearFormat = DateFormat('MM/yyyy');
  static final DateFormat _yearFormat = DateFormat('yyyy');

  // ==================== FORMATAÇÃO ====================

  /// Formata data para exibição (dd/MM/yyyy)
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Formata data para ISO (yyyy-MM-dd) - usado no banco de dados
  static String formatDateISO(DateTime date) {
    return _dateFormatISO.format(date);
  }

  /// Formata data e hora (dd/MM/yyyy HH:mm)
  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  /// Formata apenas hora (HH:mm)
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  /// Formata mês e ano (MM/yyyy)
  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  /// Formata apenas ano (yyyy)
  static String formatYear(DateTime date) {
    return _yearFormat.format(date);
  }

  // ==================== PARSING ====================

  /// Parse de string para DateTime (formato dd/MM/yyyy)
  static DateTime? parseDate(String dateStr) {
    try {
      return _dateFormat.parse(dateStr);
    } catch (e) {
      try {
        return _dateFormatISO.parse(dateStr);
      } catch (e) {
        return null;
      }
    }
  }

  /// Parse de string para DateTime (formato dd/MM/yyyy HH:mm)
  static DateTime? parseDateTime(String dateStr) {
    try {
      return _dateTimeFormat.parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  /// Verifica se a data é válida
  static bool isDataValida(String dateStr) {
    try {
      _dateFormat.parse(dateStr);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== CÁLCULOS DE IDADE ====================

  /// Calcular idade a partir da data de nascimento
  static int calcularIdade(DateTime dataNascimento) {
    final hoje = DateTime.now();
    int idade = hoje.year - dataNascimento.year;
    if (hoje.month < dataNascimento.month ||
        (hoje.month == dataNascimento.month && hoje.day < dataNascimento.day)) {
      idade--;
    }
    return idade;
  }

  /// Verificar se é criança menor de 6 anos
  static bool isMenorDeSeis(DateTime dataNascimento) {
    return calcularIdade(dataNascimento) < 6;
  }

  /// Verificar se é mulher em idade fértil (25-64 anos)
  static bool isMulherIdadeFertil(DateTime dataNascimento) {
    final idade = calcularIdade(dataNascimento);
    return idade >= 25 && idade <= 64;
  }

  /// Verificar se é homem em idade para vasectomia (25-64 anos)
  static bool isHomemIdadeVasectomia(DateTime dataNascimento) {
    final idade = calcularIdade(dataNascimento);
    return idade >= 25 && idade <= 64;
  }

  // ==================== VERIFICAÇÃO DE ATRASO ====================

  /// Verificar se está atrasado (dias)
  static bool isAtrasado(DateTime? data, int diasLimite) {
    if (data == null) return true;
    final diff = DateTime.now().difference(data).inDays;
    return diff > diasLimite;
  }

  /// Verificar consulta de diabetes atrasada (30 dias)
  static bool isConsultaDiabetesAtrasada(DateTime? dataConsulta) {
    return isAtrasado(dataConsulta, 30);
  }

  /// Verificar consulta de hipertensão atrasada (30 dias)
  static bool isConsultaHipertensaoAtrasada(DateTime? dataConsulta) {
    return isAtrasado(dataConsulta, 30);
  }

  /// Verificar preventivo atrasado (365 dias)
  static bool isPreventivoAtrasado(DateTime? dataPreventivo) {
    return isAtrasado(dataPreventivo, 365);
  }

  /// Verificar vacina atrasada (180 dias)
  static bool isVacinaAtrasada(DateTime? dataVacina) {
    return isAtrasado(dataVacina, 180);
  }

  // ==================== CÁLCULO DE DATAS ====================

  /// Calcular próximo mês
  static DateTime proximoMes(DateTime data) {
    return DateTime(data.year, data.month + 1, data.day);
  }

  /// Calcular próximo ano
  static DateTime proximoAno(DateTime data) {
    return DateTime(data.year + 1, data.month, data.day);
  }

  /// Calcular dias desde a última data
  static int diasDesde(DateTime data) {
    return DateTime.now().difference(data).inDays;
  }

  /// Calcular meses desde a última data
  static int mesesDesde(DateTime data) {
    final hoje = DateTime.now();
    int meses = (hoje.year - data.year) * 12 + (hoje.month - data.month);
    if (hoje.day < data.day) meses--;
    return meses;
  }

  /// Calcular anos desde a última data
  static int anosDesde(DateTime data) {
    final hoje = DateTime.now();
    int anos = hoje.year - data.year;
    if (hoje.month < data.month ||
        (hoje.month == data.month && hoje.day < data.day)) {
      anos--;
    }
    return anos;
  }

  // ==================== COMPARAÇÃO ====================

  /// Verifica se a data é hoje
  static bool isHoje(DateTime date) {
    final hoje = DateTime.now();
    return date.year == hoje.year &&
        date.month == hoje.month &&
        date.day == hoje.day;
  }

  /// Verifica se a data é esta semana
  static bool isEstaSemana(DateTime date) {
    final hoje = DateTime.now();
    final inicioSemana = hoje.subtract(Duration(days: hoje.weekday - 1));
    final fimSemana = inicioSemana.add(const Duration(days: 6));
    return date.isAfter(inicioSemana) && date.isBefore(fimSemana);
  }

  /// Verifica se a data é este mês
  static bool isEsteMes(DateTime date) {
    final hoje = DateTime.now();
    return date.year == hoje.year && date.month == hoje.month;
  }

  /// Verifica se a data é este ano
  static bool isEsteAno(DateTime date) {
    final hoje = DateTime.now();
    return date.year == hoje.year;
  }

  // ==================== RANGOS DE DATAS ====================

  /// Obter data atual formatada
  static String getDataAtual() {
    return formatDate(DateTime.now());
  }

  /// Obter data e hora atual formatada
  static String getDataHoraAtual() {
    return formatDateTime(DateTime.now());
  }

  /// Obter início do dia
  static DateTime getInicioDoDia(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Obter fim do dia
  static DateTime getFimDoDia(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  /// Lista de datas de um período
  static List<DateTime> getDatasPeriodo(DateTime inicio, DateTime fim) {
    List<DateTime> datas = [];
    DateTime current = inicio;
    while (current.isBefore(fim) || current.isAtSameMomentAs(fim)) {
      datas.add(current);
      current = current.add(const Duration(days: 1));
    }
    return datas;
  }

  // ==================== FORMATAÇÃO DE DURAÇÃO ====================

  /// Formatar duração
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} ${duration.inDays == 1 ? 'dia' : 'dias'}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ${duration.inHours == 1 ? 'hora' : 'horas'}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} ${duration.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return '${duration.inSeconds} ${duration.inSeconds == 1 ? 'segundo' : 'segundos'}';
    }
  }

  /// Formatar idade
  static String formatIdade(int idade) {
    return '$idade ${idade == 1 ? 'ano' : 'anos'}';
  }

  /// Formatar diferença entre datas
  static String formatDiferenca(DateTime data) {
    final diff = DateTime.now().difference(data);
    if (diff.inDays > 365) {
      final anos = (diff.inDays / 365).floor();
      return '$anos ${anos == 1 ? 'ano' : 'anos'} atrás';
    } else if (diff.inDays > 30) {
      final meses = (diff.inDays / 30).floor();
      return '$meses ${meses == 1 ? 'mês' : 'meses'} atrás';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} ${diff.inDays == 1 ? 'dia' : 'dias'} atrás';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} ${diff.inHours == 1 ? 'hora' : 'horas'} atrás';
    } else {
      return 'agora mesmo';
    }
  }

  // ==================== VALIDAÇÃO ====================

  /// Validar data de nascimento (não pode ser futura)
  static bool isDataNascimentoValida(DateTime data) {
    return data.isBefore(DateTime.now());
  }

  /// Validar data de consulta (não pode ser futura)
  static bool isDataConsultaValida(DateTime data) {
    return data.isBefore(DateTime.now()) ||
        data.isAtSameMomentAs(DateTime.now());
  }

  /// Validar data de visita (não pode ser futura)
  static bool isDataVisitaValida(DateTime data) {
    return data.isBefore(DateTime.now()) ||
        data.isAtSameMomentAs(DateTime.now());
  }
}
