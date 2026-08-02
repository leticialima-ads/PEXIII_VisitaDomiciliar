import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/paciente.dart';
import '../models/visita_domiciliar.dart';

class PacienteProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  List<Paciente> _pacientes = [];
  List<VisitaDomiciliar> _visitas = [];

  List<Paciente> get pacientes => List.unmodifiable(_pacientes);
  List<VisitaDomiciliar> get visitas => List.unmodifiable(_visitas);

  // ==================== CARREGAR DADOS ====================

  Future<void> carregarPacientes() async {
    _pacientes = await _db.getAllPacientes();
    _visitas = await _db.getAllVisitas();

    for (final paciente in _pacientes) {
      paciente.visitas = _visitas
          .where((v) => v.pacienteId == paciente.id)
          .toList();
    }

    notifyListeners();
  }

  // ==================== CRUD PACIENTES ====================

  Future<void> cadastrarPaciente(Paciente paciente) async {
    await _db.insertPaciente(paciente);
    await carregarPacientes();
  }

  Future<void> atualizarPaciente(Paciente paciente) async {
    await _db.updatePaciente(paciente);
    await carregarPacientes();
  }

  Future<void> excluirPaciente(int id) async {
    await _db.deletePaciente(id);
    await carregarPacientes();
  }

  Future<Paciente?> getPacienteById(int id) {
    return _db.getPacienteById(id);
  }

  // ==================== VISITAS ====================

  Future<void> registrarVisita(VisitaDomiciliar visita) async {
    await _db.insertVisita(visita);
    await carregarPacientes();
  }

  Future<List<VisitaDomiciliar>> getVisitasByPaciente(int pacienteId) {
    return _db.getVisitasByPaciente(pacienteId);
  }

  Future<VisitaDomiciliar?> getUltimaVisita(int pacienteId) {
    return _db.getUltimaVisita(pacienteId);
  }

  // ==================== FILTROS ====================

  List<Paciente> getPrioritarios() {
    return _pacientes.where((p) => p.isPrioritario()).toList();
  }

  List<Paciente> getDiabeticos() {
    return _pacientes.where((p) {
      final ultima = p.getUltimaVisita();
      return ultima != null && ultima.diabetes;
    }).toList();
  }

  List<Paciente> getHipertensos() {
    return _pacientes.where((p) {
      final ultima = p.getUltimaVisita();
      return ultima != null && ultima.hipertensao;
    }).toList();
  }

  List<Paciente> getMulheresSemPreventivo() {
    return _pacientes.where((p) {
      if (!p.isMulherIdadeFertil()) return false;

      final ultima = p.getUltimaVisita();

      return ultima != null && !ultima.preventivoEmDia;
    }).toList();
  }

  List<Paciente> getCriancasCadernetaAtrasada() {
    return _pacientes.where((p) {
      if (!p.isMenorDeSeis()) return false;

      final ultima = p.getUltimaVisita();

      return ultima != null && !ultima.cadernetaEmDia;
    }).toList();
  }

  List<Paciente> getHomensInteresseVasectomia() {
    return _pacientes.where((p) {
      if (!p.isHomemIdadeVasectomia()) return false;

      final ultima = p.getUltimaVisita();

      return ultima != null && ultima.interesseVasectomia;
    }).toList();
  }

  List<Paciente> getAcamados() {
    return _pacientes.where((p) {
      final ultima = p.getUltimaVisita();
      return ultima != null && ultima.acamado;
    }).toList();
  }

  // ==================== ESTATÍSTICAS ====================

  int getTotalPacientes() => _pacientes.length;

  int getTotalPrioritarios() => getPrioritarios().length;

  int getTotalDiabeticos() => getDiabeticos().length;

  int getTotalHipertensos() => getHipertensos().length;

  int getTotalAcamados() => getAcamados().length;

  // ==================== BUSCA ====================

  List<Paciente> buscarPacientes(String termo) {
    if (termo.trim().isEmpty) return _pacientes;

    final pesquisa = termo.toLowerCase();

    return _pacientes.where((p) {
      return p.nome.toLowerCase().contains(pesquisa) ||
          p.cpf.toLowerCase().contains(pesquisa) ||
          p.endereco.toLowerCase().contains(pesquisa);
    }).toList();
  }

  List<Paciente> buscarPorMicroarea(String microarea) {
    if (microarea.isEmpty) return _pacientes;

    return _pacientes
        .where((p) => p.microarea == microarea)
        .toList();
  }

  List<String> getMicroareas() {
    return _pacientes
        .map((p) => p.microarea)
        .toSet()
        .toList();
  }

  // ==================== RELATÓRIOS ====================

  Map<String, int> getEstatisticasPorMicroarea() {
    final estatisticas = <String, int>{};

    for (final paciente in _pacientes) {
      estatisticas[paciente.microarea] =
          (estatisticas[paciente.microarea] ?? 0) + 1;
    }

    return estatisticas;
  }

  Map<String, int> getPrioritariosPorMicroarea() {
    final estatisticas = <String, int>{};

    for (final paciente in getPrioritarios()) {
      estatisticas[paciente.microarea] =
          (estatisticas[paciente.microarea] ?? 0) + 1;
    }

    return estatisticas;
  }

  // ==================== LIMPAR ====================

  void limpar() {
    _pacientes.clear();
    _visitas.clear();
    notifyListeners();
  }
}
