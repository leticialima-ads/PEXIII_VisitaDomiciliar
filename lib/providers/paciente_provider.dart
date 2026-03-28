import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/paciente.dart';
import '../models/visita_domiciliar.dart';

class PacienteProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  List<Paciente> _pacientes = [];
  List<VisitaDomiciliar> _visitas = [];

  List<Paciente> get pacientes => _pacientes;
  List<VisitaDomiciliar> get visitas => _visitas;

  // ==================== CARREGAR DADOS ====================

  Future<void> carregarPacientes() async {
    _pacientes = await _db.getAllPacientes();
    _visitas = await _db.getAllVisitas();

    // Associar visitas aos pacientes
    for (var paciente in _pacientes) {
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

  Future<Paciente?> getPacienteById(int id) async {
    return await _db.getPacienteById(id);
  }

  // ==================== VISITAS ====================

  Future<void> registrarVisita(VisitaDomiciliar visita) async {
    await _db.insertVisita(visita);
    await carregarPacientes();
  }

  Future<List<VisitaDomiciliar>> getVisitasByPaciente(int pacienteId) async {
    return await _db.getVisitasByPaciente(pacienteId);
  }

  Future<VisitaDomiciliar?> getUltimaVisita(int pacienteId) async {
    return await _db.getUltimaVisita(pacienteId);
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

  int getTotalPacientes() {
    return _pacientes.length;
  }

  int getTotalPrioritarios() {
    return getPrioritarios().length;
  }

  int getTotalDiabeticos() {
    return getDiabeticos().length;
  }

  int getTotalHipertensos() {
    return getHipertensos().length;
  }

  int getTotalAcamados() {
    return getAcamados().length;
  }

  // ==================== BUSCA ====================

  List<Paciente> buscarPacientes(String termo) {
    if (termo.isEmpty) return _pacientes;
    return _pacientes
        .where(
          (p) =>
              p.nome.toLowerCase().contains(termo.toLowerCase()) ||
              p.cpf.toLowerCase().contains(termo.toLowerCase()) ||
              p.endereco.toLowerCase().contains(termo.toLowerCase()),
        )
        .toList();
  }

  List<Paciente> buscarPorMicroarea(String microarea) {
    if (microarea.isEmpty) return _pacientes;
    return _pacientes.where((p) => p.microarea == microarea).toList();
  }

  List<String> getMicroareas() {
    return _pacientes.map((p) => p.microarea).toSet().toList();
  }

  // ==================== RELATÓRIOS ====================

  Map<String, int> getEstatisticasPorMicroarea() {
    Map<String, int> estatisticas = {};
    for (var paciente in _pacientes) {
      estatisticas[paciente.microarea] =
          (estatisticas[paciente.microarea] ?? 0) + 1;
    }
    return estatisticas;
  }

  Map<String, int> getPrioritariosPorMicroarea() {
    Map<String, int> estatisticas = {};
    final prioritarios = getPrioritarios();
    for (var paciente in prioritarios) {
      estatisticas[paciente.microarea] =
          (estatisticas[paciente.microarea] ?? 0) + 1;
    }
    return estatisticas;
  }

  // ==================== LIMPAR ====================

  void limpar() {
    _pacientes = [];
    _visitas = [];
    notifyListeners();
  }
}
