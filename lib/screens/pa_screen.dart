import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/paciente_provider.dart';

class ListagemScreen extends StatefulWidget {
  const ListagemScreen({super.key});

  @override
  State<ListagemScreen> createState() => _ListagemScreenState();
}

class _ListagemScreenState extends State<ListagemScreen> {
  String _searchQuery = '';
  String _filterMicroarea = 'Todas';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PacienteProvider>(context, listen: false).carregarPacientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pacientes'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filterMicroarea = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Todas',
                child: Text('Todas microáreas'),
              ),
              ..._getMicroareas().map(
                (micro) => PopupMenuItem(
                  value: micro,
                  child: Text('Microárea $micro'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<PacienteProvider>(
        builder: (context, provider, child) {
          final pacientes = _filterPacientes(provider.pacientes);

          if (provider.pacientes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhum paciente cadastrado'),
                  SizedBox(height: 8),
                  Text(
                    'Clique no botão + para cadastrar',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: pacientes.length,
            itemBuilder: (context, index) {
              final paciente = pacientes[index];
              return _buildPacienteCard(paciente);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cadastro');
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPacienteCard(paciente) {
    final ultimaVisita = paciente.getUltimaVisita();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: paciente.isPrioritario() ? Colors.red : Colors.green,
          child: Text(
            paciente.nome[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          paciente.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${paciente.getIdade()} anos | ${paciente.microarea}'),
        trailing: paciente.isPrioritario()
            ? const Icon(Icons.warning, color: Colors.red)
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _buildInfoRow('CPF', paciente.cpf),
                _buildInfoRow(
                  'Data Nascimento',
                  _formatDate(paciente.dataNascimento),
                ),
                _buildInfoRow('Idade', '${paciente.getIdade()} anos'),
                _buildInfoRow(
                  'Sexo',
                  paciente.sexo == 'MASCULINO' ? 'Masculino' : 'Feminino',
                ),
                _buildInfoRow('Microárea', paciente.microarea),
                _buildInfoRow('Endereço', paciente.endereco),
                if (ultimaVisita != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow('Última visita', ultimaVisita.dataFormatada),
                  _buildInfoRow('Motivo', ultimaVisita.motivo),
                ],
                if (paciente.isPrioritario()) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'PRIORITÁRIO: ${paciente.getPrioridadeDescricao()}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/visita',
                          arguments: paciente.id,
                        );
                      },
                      icon: const Icon(Icons.home_work),
                      label: const Text('Visita'),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/paciente',
                          arguments: paciente.id,
                        );
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('Detalhes'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  List<Paciente> _filterPacientes(List<Paciente> pacientes) {
    var filtered = pacientes;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (p) =>
                p.nome.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.cpf.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.endereco.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    if (_filterMicroarea != 'Todas') {
      filtered = filtered
          .where((p) => p.microarea == _filterMicroarea)
          .toList();
    }

    return filtered;
  }

  List<String> _getMicroareas() {
    final provider = Provider.of<PacienteProvider>(context, listen: false);
    return provider.pacientes.map((p) => p.microarea).toSet().toList();
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buscar Paciente'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Digite nome, CPF ou endereço',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
              });
              Navigator.pop(context);
            },
            child: const Text('Limpar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
