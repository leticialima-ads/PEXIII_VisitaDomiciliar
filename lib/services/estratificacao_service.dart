import '../models/paciente.dart';
import '../models/visita_domiciliar.dart';
import '../providers/paciente_provider.dart';

class EstratificacaoService {
  final PacienteProvider _provider;

  EstratificacaoService(this._provider);

  // ==================== RELATÓRIO COMPLETO ====================

  Map<String, dynamic> gerarRelatorioCompleto() {
    final pacientes = _provider.pacientes;

    final diabeticos = _provider.getDiabeticos();
    final hipertensos = _provider.getHipertensos();
    final mulheresSemPreventivo = _provider.getMulheresSemPreventivo();
    final criancasAtrasadas = _provider.getCriancasCadernetaAtrasada();
    final homensInteresse = _provider.getHomensInteresseVasectomia();
    final acamados = _provider.getAcamados();
    final prioritarios = _provider.getPrioritarios();

    return {
      'total': pacientes.length,
      'diabeticos': diabeticos.length,
      'hipertensos': hipertensos.length,
      'mulheresSemPreventivo': mulheresSemPreventivo.length,
      'criancasAtrasadas': criancasAtrasadas.length,
      'homensInteresseVasectomia': homensInteresse.length,
      'acamados': acamados.length,
      'prioritarios': prioritarios.length,
    };
  }

  // ==================== PLANEJAMENTO DE BUSCA ATIVA ====================

  Map<String, List<Paciente>> planejarBuscaAtiva() {
    final prioritarios = _provider.getPrioritarios();
    final Map<String, List<Paciente>> porMicroarea = {};

    for (var paciente in prioritarios) {
      if (!porMicroarea.containsKey(paciente.microarea)) {
        porMicroarea[paciente.microarea] = [];
      }
      porMicroarea[paciente.microarea]!.add(paciente);
    }

    return porMicroarea;
  }

  // ==================== ESTATÍSTICAS POR MICROÁREA ====================

  Map<String, Map<String, dynamic>> getEstatisticasPorMicroarea() {
    final pacientes = _provider.pacientes;
    final Map<String, Map<String, dynamic>> estatisticas = {};

    for (var paciente in pacientes) {
      final micro = paciente.microarea;
      if (!estatisticas.containsKey(micro)) {
        estatisticas[micro] = {
          'total': 0,
          'prioritarios': 0,
          'diabeticos': 0,
          'hipertensos': 0,
          'mulheresSemPreventivo': 0,
          'criancasAtrasadas': 0,
          'acamados': 0,
          'homensInteresseVasectomia': 0,
        };
      }

      var stats = estatisticas[micro]!;
      stats['total'] = stats['total'] + 1;

      if (paciente.isPrioritario())
        stats['prioritarios'] = stats['prioritarios'] + 1;

      final ultimaVisita = paciente.getUltimaVisita();
      if (ultimaVisita != null) {
        if (ultimaVisita.diabetes)
          stats['diabeticos'] = stats['diabeticos'] + 1;
        if (ultimaVisita.hipertensao)
          stats['hipertensos'] = stats['hipertensos'] + 1;
        if (paciente.isMulherIdadeFertil() && !ultimaVisita.preventivoEmDia) {
          stats['mulheresSemPreventivo'] = stats['mulheresSemPreventivo'] + 1;
        }
        if (paciente.isMenorDeSeis() && !ultimaVisita.cadernetaEmDia) {
          stats['criancasAtrasadas'] = stats['criancasAtrasadas'] + 1;
        }
        if (ultimaVisita.acamado) stats['acamados'] = stats['acamados'] + 1;
        if (paciente.isHomemIdadeVasectomia() &&
            ultimaVisita.interesseVasectomia) {
          stats['homensInteresseVasectomia'] =
              stats['homensInteresseVasectomia'] + 1;
        }
      }
    }

    return estatisticas;
  }

  // ==================== TENDÊNCIAS DE SAÚDE ====================

  Map<String, dynamic> getTendenciasSaude() {
    final pacientes = _provider.pacientes;
    int diabetesControlada = 0;
    int diabetesDescontrolada = 0;
    int hipertensaoControlada = 0;
    int hipertensaoDescontrolada = 0;
    int cadernetaAtrasada = 0;
    int preventivoAtrasado = 0;

    for (var paciente in pacientes) {
      final ultimaVisita = paciente.getUltimaVisita();
      if (ultimaVisita != null) {
        // Diabetes
        if (ultimaVisita.diabetes) {
          if (ultimaVisita.isConsultaDiabetesAtrasada()) {
            diabetesDescontrolada++;
          } else {
            diabetesControlada++;
          }
        }

        // Hipertensão
        if (ultimaVisita.hipertensao) {
          if (ultimaVisita.isConsultaHipertensaoAtrasada()) {
            hipertensaoDescontrolada++;
          } else {
            hipertensaoControlada++;
          }
        }

        // Caderneta
        if (paciente.isMenorDeSeis() && !ultimaVisita.cadernetaEmDia) {
          cadernetaAtrasada++;
        }

        // Preventivo
        if (paciente.isMulherIdadeFertil() && !ultimaVisita.preventivoEmDia) {
          preventivoAtrasado++;
        }
      }
    }

    return {
      'diabetes': {
        'controlada': diabetesControlada,
        'descontrolada': diabetesDescontrolada,
        'total': diabetesControlada + diabetesDescontrolada,
      },
      'hipertensao': {
        'controlada': hipertensaoControlada,
        'descontrolada': hipertensaoDescontrolada,
        'total': hipertensaoControlada + hipertensaoDescontrolada,
      },
      'cadernetaAtrasada': cadernetaAtrasada,
      'preventivoAtrasado': preventivoAtrasado,
    };
  }

  // ==================== INDICADORES DE SAÚDE ====================

  Map<String, double> getIndicadores() {
    final pacientes = _provider.pacientes;
    final total = pacientes.length;

    if (total == 0) return {};

    final diabeticos = _provider.getDiabeticos().length;
    final hipertensos = _provider.getHipertensos().length;
    final prioritarios = _provider.getPrioritarios().length;
    final acamados = _provider.getAcamados().length;

    return {
      'percentualDiabeticos': (diabeticos / total) * 100,
      'percentualHipertensos': (hipertensos / total) * 100,
      'percentualPrioritarios': (prioritarios / total) * 100,
      'percentualAcamados': (acamados / total) * 100,
    };
  }

  // ==================== LISTAS DETALHADAS ====================

  List<Map<String, dynamic>> getListaPrioritariosDetalhada() {
    final prioritarios = _provider.getPrioritarios();
    List<Map<String, dynamic>> lista = [];

    for (var paciente in prioritarios) {
      final ultimaVisita = paciente.getUltimaVisita();
      lista.add({
        'id': paciente.id,
        'nome': paciente.nome,
        'idade': paciente.getIdade(),
        'microarea': paciente.microarea,
        'endereco': paciente.endereco,
        'cpf': paciente.cpf,
        'motivos': paciente.getPrioridadeDescricao(),
        'ultimaVisita': ultimaVisita?.dataFormatada ?? 'Nenhuma',
        'acamado': ultimaVisita?.acamado ?? false,
      });
    }

    return lista;
  }

  List<Map<String, dynamic>> getListaDiabeticosDetalhada() {
    final diabeticos = _provider.getDiabeticos();
    List<Map<String, dynamic>> lista = [];

    for (var paciente in diabeticos) {
      final ultimaVisita = paciente.getUltimaVisita();
      lista.add({
        'id': paciente.id,
        'nome': paciente.nome,
        'idade': paciente.getIdade(),
        'microarea': paciente.microarea,
        'endereco': paciente.endereco,
        'ultimaConsulta': ultimaVisita?.dataConsultaDiabetes != null
            ? _formatDate(ultimaVisita!.dataConsultaDiabetes!)
            : 'Não registrada',
        'atrasado': ultimaVisita?.isConsultaDiabetesAtrasada() ?? false,
      });
    }

    return lista;
  }

  List<Map<String, dynamic>> getListaHipertensosDetalhada() {
    final hipertensos = _provider.getHipertensos();
    List<Map<String, dynamic>> lista = [];

    for (var paciente in hipertensos) {
      final ultimaVisita = paciente.getUltimaVisita();
      lista.add({
        'id': paciente.id,
        'nome': paciente.nome,
        'idade': paciente.getIdade(),
        'microarea': paciente.microarea,
        'endereco': paciente.endereco,
        'ultimaConsulta': ultimaVisita?.dataConsultaHipertensao != null
            ? _formatDate(ultimaVisita!.dataConsultaHipertensao!)
            : 'Não registrada',
        'atrasado': ultimaVisita?.isConsultaHipertensaoAtrasada() ?? false,
      });
    }

    return lista;
  }

  List<Map<String, dynamic>> getListaMulheresSemPreventivoDetalhada() {
    final mulheres = _provider.getMulheresSemPreventivo();
    List<Map<String, dynamic>> lista = [];

    for (var paciente in mulheres) {
      final ultimaVisita = paciente.getUltimaVisita();
      lista.add({
        'id': paciente.id,
        'nome': paciente.nome,
        'idade': paciente.getIdade(),
        'microarea': paciente.microarea,
        'endereco': paciente.endereco,
        'ultimoPreventivo': ultimaVisita?.dataUltimoPreventivo != null
            ? _formatDate(ultimaVisita!.dataUltimoPreventivo!)
            : 'Nunca fez',
        'metodoContraceptivo':
            ultimaVisita?.metodoContraceptivo?.descricao ?? 'Não informado',
      });
    }

    return lista;
  }

  List<Map<String, dynamic>> getListaCriancasCadernetaAtrasadaDetalhada() {
    final criancas = _provider.getCriancasCadernetaAtrasada();
    List<Map<String, dynamic>> lista = [];

    for (var paciente in criancas) {
      lista.add({
        'id': paciente.id,
        'nome': paciente.nome,
        'idade': paciente.getIdade(),
        'microarea': paciente.microarea,
        'endereco': paciente.endereco,
        'responsavel': 'Responsável não cadastrado',
      });
    }

    return lista;
  }

  List<Map<String, dynamic>> getListaHomensInteresseVasectomiaDetalhada() {
    final homens = _provider.getHomensInteresseVasectomia();
    List<Map<String, dynamic>> lista = [];

    for (var paciente in homens) {
      lista.add({
        'id': paciente.id,
        'nome': paciente.nome,
        'idade': paciente.getIdade(),
        'microarea': paciente.microarea,
        'endereco': paciente.endereco,
        'status': 'Aguardando encaminhamento',
      });
    }

    return lista;
  }

  // ==================== EXPORTAR DADOS ====================

  String exportarParaCSV() {
    final pacientes = _provider.pacientes;
    StringBuffer csv = StringBuffer();

    // Cabeçalho
    csv.writeln(
      'ID,Nome,Idade,Sexo,CPF,Microárea,Endereço,Prioritário,Motivos,Última Visita',
    );

    // Dados
    for (var paciente in pacientes) {
      final ultimaVisita = paciente.getUltimaVisita();
      csv.writeln(
        '${paciente.id},'
        '"${paciente.nome}",'
        '${paciente.getIdade()},'
        '${paciente.sexo == 'MASCULINO' ? 'Masculino' : 'Feminino'},'
        '"${paciente.cpf}",'
        '"${paciente.microarea}",'
        '"${paciente.endereco}",'
        '${paciente.isPrioritario() ? 'Sim' : 'Não'},'
        '"${paciente.getPrioridadeDescricao()}",'
        '"${ultimaVisita?.dataFormatada ?? ''}"',
      );
    }

    return csv.toString();
  }

  // ==================== HELPERS ====================

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
