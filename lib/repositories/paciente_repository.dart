import '../database/database_helper.dart';
import '../models/paciente.dart';
import '../models/visita_domiciliar.dart';

class PacienteRepository {
  final DatabaseHelper _db = DatabaseHelper();

  // ==================== PACIENTES ====================

  Future<int> insert(Paciente paciente) {
    return _db.insertPaciente(paciente);
  }

  Future<List<Paciente>> getAll() {
    return _db.getAllPacientes();
  }

  Future<Paciente?> getById(int id) {
    return _db.getPacienteById(id);
  }

  Future<int> update(Paciente paciente) {
    return _db.updatePaciente(paciente);
  }

  Future<int> delete(int id) {
    return _db.deletePaciente(id);
  }

  // ==================== VISITAS ====================

  Future<int> insertVisita(VisitaDomiciliar visita) {
    return _db.insertVisita(visita);
  }

  Future<List<VisitaDomiciliar>> getAllVisitas() {
    return _db.getAllVisitas();
  }

  Future<List<VisitaDomiciliar>> getVisitasByPaciente(
    int pacienteId,
  ) {
    return _db.getVisitasByPaciente(pacienteId);
  }

  Future<VisitaDomiciliar?> getUltimaVisita(
    int pacienteId,
  ) {
    return _db.getUltimaVisita(pacienteId);
  }

  Future<int> updateVisita(
    VisitaDomiciliar visita,
  ) {
    return _db.updateVisita(visita);
  }

  Future<int> deleteVisita(int id) {
    return _db.deleteVisita(id);
  }

  // ==================== FILTROS ====================

  Future<List<Paciente>> getDiabeticos() async {
    final todos = await getAll();
    final List<Paciente> diabeticos = [];

    for (final paciente in todos) {
      final ultima = await getUltimaVisita(
        paciente.id!,
      );

      if (ultima != null && ultima.diabetes) {
        diabeticos.add(paciente);
      }
    }

    return diabeticos;
  }

  Future<List<Paciente>> getHipertensos() async {
    final todos = await getAll();
    final List<Paciente> hipertensos = [];

    for (final paciente in todos) {
      final ultima = await getUltimaVisita(
        paciente.id!,
      );

      if (ultima != null && ultima.hipertensao) {
        hipertensos.add(paciente);
      }
    }

    return hipertensos;
  }

  Future<List<Paciente>> getMulheresSemPreventivo() async {
    final todos = await getAll();
    final List<Paciente> resultado = [];

    for (final paciente in todos) {
      if (!paciente.isMulherIdadeFertil()) {
        continue;
      }

      final ultima = await getUltimaVisita(
        paciente.id!,
      );

      if (ultima != null &&
          !ultima.preventivoEmDia) {
        resultado.add(paciente);
      }
    }

    return resultado;
  }

  Future<List<Paciente>>
      getCriancasCadernetaAtrasada() async {
    final todos = await getAll();
    final List<Paciente> resultado = [];

    for (final paciente in todos) {
      if (!paciente.isMenorDeSeis()) {
        continue;
      }

      final ultima = await getUltimaVisita(
        paciente.id!,
      );

      if (ultima != null &&
          !ultima.cadernetaEmDia) {
        resultado.add(paciente);
      }
    }

    return resultado;
  }

  Future<List<Paciente>>
      getHomensInteresseVasectomia() async {
    final todos = await getAll();
    final List<Paciente> resultado = [];

    for (final paciente in todos) {
      if (!paciente.isHomemIdadeVasectomia()) {
        continue;
      }

      final ultima = await getUltimaVisita(
        paciente.id!,
      );

      if (ultima != null &&
          ultima.interesseVasectomia) {
        resultado.add(paciente);
      }
    }

    return resultado;
  }

  Future<List<Paciente>> getAcamados() async {
    final todos = await getAll();
    final List<Paciente> resultado = [];

    for (final paciente in todos) {
      final ultima = await getUltimaVisita(
        paciente.id!,
      );

      if (ultima != null &&
          ultima.acamado) {
        resultado.add(paciente);
      }
    }

    return resultado;
  }

  Future<List<Paciente>> getPrioritarios() async {
    final todos = await getAll();
    final List<Paciente> resultado = [];

    for (final paciente in todos) {
      final visitas =
          await getVisitasByPaciente(
        paciente.id!,
      );

      paciente.visitas = visitas;

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
    final prioritarios =
        await getPrioritarios();

    return prioritarios.length;
  }

  Future<Map<String, int>>
      getEstatisticasPorMicroarea() async {
    final todos = await getAll();

    final Map<String, int> estatisticas =
        {};

    for (final paciente in todos) {
      estatisticas[paciente.microarea] =
          (estatisticas[paciente.microarea] ??
                  0) +
              1;
    }

    return estatisticas;
  }
}
