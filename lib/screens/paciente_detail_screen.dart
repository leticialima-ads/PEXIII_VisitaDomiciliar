import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/paciente.dart';
import '../models/visita_domiciliar.dart';
import '../providers/paciente_provider.dart';

class PacienteDetailScreen extends StatefulWidget {
  final int pacienteId;
  const PacienteDetailScreen({super.key, required this.pacienteId});

  @override
  State<PacienteDetailScreen> createState() => _PacienteDetailScreenState();
}

class _PacienteDetailScreenState extends State<PacienteDetailScreen> {
  Paciente? _paciente;
  bool _isLoading = true;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final provider = Provider.of<PacienteProvider>(context, listen: false);
    await provider.carregarPacientes();

    _paciente = provider.pacientes.firstWhere(
      (p) => p.id == widget.pacienteId,
      orElse: () => throw Exception('Paciente não encontrado'),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_paciente == null) {
      return const Scaffold(
        body: Center(child: Text('Paciente não encontrado')),
      );
    }

    final ultimaVisita = _paciente!.getUltimaVisita();

    return Scaffold(
      appBar: AppBar(
        title: Text(_paciente!.nome),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editarPaciente(),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmarExclusao(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildResumoCard(ultimaVisita),
          TabBar(
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
            tabs: const [
              Tab(icon: Icon(Icons.person), text: 'Dados'),
              Tab(icon: Icon(Icons.history), text: 'Visitas'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildDadosTab(ultimaVisita),
                _buildHistoricoVisitasTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/visita',
            arguments: _paciente!.id,
          ).then((_) => _carregarDados());
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.home_work),
      ),
    );
  }

  Widget _buildResumoCard(VisitaDomiciliar? ultimaVisita) {
    final isPrioritario = _paciente!.isPrioritario();
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPrioritario ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isPrioritario ? Colors.red : Colors.green),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoChip(
                'Idade',
                '${_paciente!.getIdade()} anos',
                Icons.cake,
              ),
              _buildInfoChip('Microárea', _paciente!.microarea, Icons.map),
              _buildInfoChip(
                'Prioritário',
                isPrioritario ? 'SIM' : 'NÃO',
                Icons.warning,
                color: isPrioritario ? Colors.red : Colors.green,
              ),
            ],
          ),
          if (isPrioritario) ...[
            const Divider(),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _paciente!.getPrioridadeDescricao(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        Icon(icon, size: 20, color: color ?? Colors.grey),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDadosTab(VisitaDomiciliar? ultimaVisita) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Dados Pessoais', [
            _buildInfoRow('Nome', _paciente!.nome),
            _buildInfoRow(
              'Data Nascimento',
              _formatDate(_paciente!.dataNascimento),
            ),
            _buildInfoRow('Idade', '${_paciente!.getIdade()} anos'),
            _buildInfoRow(
              'Sexo',
              _paciente!.sexo == 'MASCULINO' ? 'Masculino' : 'Feminino',
            ),
            _buildInfoRow('CPF', _paciente!.cpf),
            _buildInfoRow('Microárea', _paciente!.microarea),
            _buildInfoRow('Endereço', _paciente!.endereco),
          ]),
          const SizedBox(height: 16),
          if (ultimaVisita != null) ...[
            _buildSection('Última Visita', [
              _buildInfoRow('Data', ultimaVisita.dataFormatada),
              _buildInfoRow('Motivo', ultimaVisita.motivo),
              _buildInfoRow('Observações', ultimaVisita.observacoes),
              _buildInfoRow('Acamado', ultimaVisita.acamado ? 'Sim' : 'Não'),
              if (ultimaVisita.diabetes) ...[
                _buildInfoRow('Diabetes', 'Sim'),
                if (ultimaVisita.dataConsultaDiabetes != null)
                  _buildInfoRow(
                    'Última consulta',
                    _formatDate(ultimaVisita.dataConsultaDiabetes!),
                  ),
              ],
              if (ultimaVisita.hipertensao) ...[
                _buildInfoRow('Hipertensão', 'Sim'),
                if (ultimaVisita.dataConsultaHipertensao != null)
                  _buildInfoRow(
                    'Última consulta',
                    _formatDate(ultimaVisita.dataConsultaHipertensao!),
                  ),
              ],
              if (_paciente!.isMenorDeSeis())
                _buildInfoRow(
                  'Caderneta',
                  ultimaVisita.cadernetaEmDia ? 'Em dia' : 'Atrasada',
                  color: ultimaVisita.cadernetaEmDia ? null : Colors.red,
                ),
              if (_paciente!.isMulherIdadeFertil()) ...[
                _buildInfoRow(
                  'Preventivo',
                  ultimaVisita.preventivoEmDia ? 'Em dia' : 'Atrasado',
                  color: ultimaVisita.preventivoEmDia ? null : Colors.red,
                ),
                if (ultimaVisita.dataUltimoPreventivo != null)
                  _buildInfoRow(
                    'Data preventivo',
                    _formatDate(ultimaVisita.dataUltimoPreventivo!),
                  ),
                if (ultimaVisita.metodoContraceptivo != null)
                  _buildInfoRow(
                    'Método',
                    ultimaVisita.metodoContraceptivo!.descricao,
                  ),
              ],
              if (_paciente!.isHomemIdadeVasectomia())
                _buildInfoRow(
                  'Vasectomia',
                  ultimaVisita.interesseVasectomia ? 'Interessado' : 'Não',
                ),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _buildHistoricoVisitasTab() {
    if (_paciente!.visitas.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_work, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Nenhuma visita registrada'),
            SizedBox(height: 8),
            Text('Clique no botão + para registrar'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _paciente!.visitas.length,
      itemBuilder: (context, index) {
        final visita = _paciente!.visitas[index];
        return Card(
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: visita.acamado ? Colors.red : Colors.green,
              child: Icon(
                visita.acamado ? Icons.bed : Icons.home_work,
                color: Colors.white,
              ),
            ),
            title: Text(visita.motivo),
            subtitle: Text(visita.dataFormatada),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Motivo', visita.motivo),
                    _buildInfoRow('Data', visita.dataFormatada),
                    if (visita.acamado)
                      _buildInfoRow('Acamado', 'Sim', color: Colors.red),
                    if (visita.observacoes.isNotEmpty)
                      _buildInfoRow('Observações', visita.observacoes),
                    if (visita.diabetes) ...[
                      const Divider(),
                      _buildInfoRow('Diabetes', 'Sim'),
                      if (visita.dataConsultaDiabetes != null)
                        _buildInfoRow(
                          'Última consulta',
                          _formatDate(visita.dataConsultaDiabetes!),
                        ),
                    ],
                    if (visita.hipertensao) ...[
                      _buildInfoRow('Hipertensão', 'Sim'),
                      if (visita.dataConsultaHipertensao != null)
                        _buildInfoRow(
                          'Última consulta',
                          _formatDate(visita.dataConsultaHipertensao!),
                        ),
                    ],
                    if (!visita.cadernetaEmDia) ...[
                      _buildInfoRow('Caderneta', 'Atrasada', color: Colors.red),
                    ],
                    if (!visita.preventivoEmDia) ...[
                      _buildInfoRow(
                        'Preventivo',
                        'Atrasado',
                        color: Colors.red,
                      ),
                      if (visita.dataUltimoPreventivo != null)
                        _buildInfoRow(
                          'Data',
                          _formatDate(visita.dataUltimoPreventivo!),
                        ),
                      if (visita.metodoContraceptivo != null)
                        _buildInfoRow(
                          'Método',
                          visita.metodoContraceptivo!.descricao,
                        ),
                    ],
                    if (visita.interesseVasectomia) ...[
                      _buildInfoRow(
                        'Vasectomia',
                        'Interessado',
                        color: Colors.blue,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          const Divider(height: 0),
          ...children.map(
            (child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: child,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: color != null ? TextStyle(color: color) : null,
          ),
        ),
      ],
    );
  }

  void _editarPaciente() {
    Navigator.pushNamed(
      context,
      '/editar',
      arguments: _paciente!.id,
    ).then((_) => _carregarDados());
  }

  void _confirmarExclusao() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir ${_paciente!.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final provider = Provider.of<PacienteProvider>(
                context,
                listen: false,
              );
              await provider.excluirPaciente(_paciente!.id!);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Paciente excluído!')),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
