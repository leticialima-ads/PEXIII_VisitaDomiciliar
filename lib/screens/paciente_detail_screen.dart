```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/paciente.dart';
import '../models/visita_domiciliar.dart';
import '../providers/paciente_provider.dart';

class PacienteDetailScreen extends StatefulWidget {
  final int pacienteId;

  const PacienteDetailScreen({
    super.key,
    required this.pacienteId,
  });

  @override
  State<PacienteDetailScreen> createState() =>
      _PacienteDetailScreenState();
}

class _PacienteDetailScreenState
    extends State<PacienteDetailScreen> {
  Paciente? _paciente;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final provider = Provider.of<PacienteProvider>(
      context,
      listen: false,
    );

    await provider.carregarPacientes();

    if (!mounted) return;

    final encontrados = provider.pacientes.where(
      (p) => p.id == widget.pacienteId,
    );

    if (encontrados.isEmpty) {
      setState(() {
        _isLoading = false;
        _paciente = null;
      });
      return;
    }

    _paciente = encontrados.first;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_paciente == null) {
      return const Scaffold(
        body: Center(
          child: Text('Paciente não encontrado'),
        ),
      );
    }

    final ultimaVisita =
        _paciente!.getUltimaVisita();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_paciente!.nome),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _editarPaciente,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed:
                  _confirmarExclusao,
            ),
          ],
        ),
        body: Column(
          children: [
            _buildResumoCard(
              ultimaVisita,
            ),

            const TabBar(
              indicatorColor:
                  Colors.green,
              labelColor: Colors.green,
              unselectedLabelColor:
                  Colors.grey,
              tabs: [
                Tab(
                  icon: Icon(Icons.person),
                  text: 'Dados',
                ),
                Tab(
                  icon: Icon(Icons.history),
                  text: 'Visitas',
                ),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _buildDadosTab(),
                  _buildHistoricoVisitasTab(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton:
            FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/visita',
              arguments:
                  _paciente!.id,
            ).then(
              (_) =>
                  _carregarDados(),
            );
          },
          backgroundColor:
              Colors.green,
          child: const Icon(
            Icons.home_work,
          ),
        ),
      ),
    );
  }

  Widget _buildResumoCard(
    VisitaDomiciliar?
        ultimaVisita,
  ) {
    final isPrioritario =
        _paciente!.isPrioritario();

    return Container(
      margin: const EdgeInsets.all(
        12,
      ),
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPrioritario
            ? Colors.red.shade50
            : Colors.green.shade50,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: isPrioritario
              ? Colors.red
              : Colors.green,
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceAround,
        children: [
          _buildInfoChip(
            'Idade',
            '${_paciente!.getIdade()} anos',
            Icons.cake,
          ),
          _buildInfoChip(
            'Microárea',
            _paciente!.microarea,
            Icons.map,
          ),
          _buildInfoChip(
            'Prioritário',
            isPrioritario
                ? 'SIM'
                : 'NÃO',
            Icons.warning,
            color: isPrioritario
                ? Colors.red
                : Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color:
              color ?? Colors.green,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
            color:
                color ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDadosTab() {
    return ListView(
      padding:
          const EdgeInsets.all(16),
      children: [
        ListTile(
          leading:
              const Icon(Icons.badge),
          title: const Text('CPF'),
          subtitle: Text(
            _paciente!.cpf,
          ),
        ),

        ListTile(
          leading: const Icon(
            Icons.calendar_today,
          ),
          title: const Text(
            'Data de nascimento',
          ),
          subtitle: Text(
            _paciente!
                .dataNascimento
                .toString(),
          ),
        ),

        ListTile(
          leading:
              const Icon(Icons.home),
          title: const Text(
            'Endereço',
          ),
          subtitle: Text(
            _paciente!.endereco,
          ),
        ),

        ListTile(
          leading:
              const Icon(Icons.map),
          title: const Text(
            'Microárea',
          ),
          subtitle: Text(
            _paciente!.microarea,
          ),
        ),
      ],
    );
  }

  Widget
      _buildHistoricoVisitasTab() {
    final visitas =
        _paciente!.visitas;

    if (visitas.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma visita cadastrada',
        ),
      );
    }

    return ListView.builder(
      itemCount: visitas.length,
      itemBuilder: (context, index) {
        final visita = visitas[index];

        return Card(
          margin:
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
          child: ListTile(
            leading: const Icon(
              Icons.home_work,
              color: Colors.green,
            ),

            // USA O CAMPO data DA SUA MODEL
            title: Text(
              visita.data.toString(),
            ),

            subtitle: const Text(
              'Visita domiciliar registrada',
            ),
          ),
        );
      },
    );
  }

  void _editarPaciente() {
    Navigator.pushNamed(
      context,
      '/paciente-form',
      arguments: _paciente,
    ).then(
      (_) => _carregarDados(),
    );
  }

  Future<void>
      _confirmarExclusao() async {
    final confirmado =
        await showDialog<bool>(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text(
                  'Excluir paciente',
                ),
                content: Text(
                  'Deseja realmente excluir ${_paciente!.nome}?',
                ),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(
                          context,
                          false,
                        ),
                    child: const Text(
                      'Cancelar',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pop(
                          context,
                          true,
                        ),
                    style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red,
                        ),
                    child: const Text(
                      'Excluir',
                    ),
                  ),
                ],
              ),
        );

    if (confirmado != true) {
      return;
    }

    final provider =
        Provider.of<PacienteProvider>(
          context,
          listen: false,
        );

    await provider.excluirPaciente(
      _paciente!.id!,
    );

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          'Paciente excluído com sucesso',
        ),
      ),
    );
  }
}
```
