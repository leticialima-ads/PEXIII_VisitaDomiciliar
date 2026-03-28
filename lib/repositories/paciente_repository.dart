import '../database/database_helper.dart';
import '../models/paciente.dart';
import '../models/visita_domiciliar.dart';

class PacienteRepository {
  final DatabaseHelper _db = DatabaseHelper();

  // ==================== PACIENTES ====================

  Future<int> insert(Paciente paciente) async {
    return await _db.insertPaciente(paciente);
  }

  Future<List<Paciente>> getAll() async {
    return await _db.getAllPacientes();
  }

  Future<Paciente?> getById(int id) async {
    return await _db.getPacienteById(id);
  }

  Future<int> update(Paciente paciente) async {
    return await _db.updatePaciente(paciente);
  }

  Future<int> delete(int id) async {
    return await _db.deletePaciente(id);
  }

  // ==================== VISITAS ====================

  Future<int> insertVisita(VisitaDomiciliar visita) async {
    return await _db.insertVisita(visita);
  }

  Future<List<VisitaDomiciliar>> getAllVisitas() async {
    return await _db.getAllVisitas();
  }

  Future<List<VisitaDomiciliar>> getVisitasByPaciente(int pacienteId) async {
    return await _db.getVisitasByPaciente(pacienteId);
  }

  Future<VisitaDomiciliar?> getUltimaVisita(int pacienteId) async {
    return await _db.getUltimaVisita(pacienteId);
  }

  Future<int> updateVisita(VisitaDomiciliar visita) async {
    return await _db.updateVisita(visita);
  }

  Future<int> deleteVisita(int id) async {
    return await _db.deleteVisita(id);
  }

  // ==================== FILTROS (com dados do banco) ====================

  Future<List<Paciente>> getDiabeticos() async {
    final todos = await getAll();
    final List<Paciente> diabeticos = [];

    for (var paciente in todos) {
      final ultima = await getUltimaVisita(paciente.id!);
      if (ultima != null && ultima.diabetes) {
        diabeticos.add(paciente);
      }
    }
    return diabeticos;
  }

  Future<List<Paciente>> getHipertensos() async {
    final todos = await getAll();
    final List<Paciente> hipertensos = [];

    for (var paciente in todos) {
      final ultima = await getUltimaVisita(paciente.id!);
      if (ultima != null && ultima.hipertensao) {
        hipertensos.add(paciente);
      }
    }
    return hipertensos;
  }

  Future<List<Paciente>> getMulheresSemPreventivo() async {
    final todos = await getAll();
    final List<Paciente> resultado = [];

    for (var paciente in todos) {
      if (!paciente.isMulherIdadeFertil()) continue;
      final ultima = await getUltimaVisita(paciente.id!);
      if (ultima != null && !ultima.preventivoEmDia) {
        resultado.add(paciente);
      }
    }
    return resultado;
  }

  Future<List<Paciente>> getCriancasCadernetaAtrasada() async {
    final todos = await getAll();
    final List<Paciente> resultado = [];

    for (var paciente in todos) {
      if (!paciente.isMenorDeSeis()) continue;
      final ultima = await getUltimaVisita(paciente.id!);
      if (ultima != null && !ultima.cadernetaEmDia) {
        resultado.add(paciente);
      }
    }
    return resultado;
  }

  Future<List<Paciente>> getHomensInteresseVasectomia() async {
    final todos = await getAll();
    final List<Paciente> resultado = [];

    for (var paciente in todos) {
      if (!paciente.isHomemIdadeVasectomia()) continue;
      final ultima = await getUltimaVisita(paciente.id!);
      if (ultima != null && ultima.interesseVasectomia) {
        resultado.add(paciente);
      }
    }
    return resultado;
  }

  Future<List<Paciente>> getAcamados() async {
    final todos = await getAll();
    final List<Paciente> resultado = [];

    for (var paciente in todos) {
      final ultima = await getUltimaVisita(paciente.id!);
      if (ultima != null && ultima.acamado) {
        resultado.add(paciente);
      }
    }
    return resultado;
  }

  Future<List<Paciente>> getPrioritarios() async {
    final todos = await getAll();
    final List<Paciente> resultado = [];

    for (var paciente in todos) {
      if (paciente.isPrioritario()) {
        resultado.add(paciente);
      }
    }
    return resultado;
  }

  // ==================== ESTATÍSTICAS ====================

  Future<int> getTotalPacientes() async {
    final todos = await getAll();
    return todos.length;
  }

  Future<int> getTotalPrioritarios() async {
    final prioritarios = await getPrioritarios();
    return prioritarios.length;
  }

  Future<Map<String, int>> getEstatisticasPorMicroarea() async {
    final todos = await getAll();
    Map<String, int> estatisticas = {};
    for (var paciente in todos) {
      estatisticas[paciente.microarea] =
          (estatisticas[paciente.microarea] ?? 0) + 1;
    }
    return estatisticas;
  }
}
