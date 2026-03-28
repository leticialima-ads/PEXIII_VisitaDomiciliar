import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/paciente_provider.dart';

class FiltrosScreen extends StatefulWidget {
  const FiltrosScreen({super.key});

  @override
  State<FiltrosScreen> createState() => _FiltrosScreenState();
}

class _FiltrosScreenState extends State<FiltrosScreen> {
  String _filtroAtual = 'todos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Chips de filtro
          Container(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('Todos', 'todos', Icons.people),
                _buildFilterChip('Diabéticos', 'diabeticos', Icons.bloodtype),
                _buildFilterChip('Hipertensos', 'hipertensos', Icons.favorite),
                _buildFilterChip(
                  'Mulheres sem Preventivo',
                  'preventivo',
                  Icons.woman,
                ),
                _buildFilterChip(
                  'Crianças Caderneta',
                  'criancas',
                  Icons.child_care,
                ),
                _buildFilterChip(
                  'Interesse Vasectomia',
                  'vasectomia',
                  Icons.male,
                ),
                _buildFilterChip('Acamados', 'acamados', Icons.bed),
                _buildFilterChip('Prioritários', 'prioritarios', Icons.warning),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Consumer<PacienteProvider>(
              builder: (context, provider, child) {
                final pacientes = _filtrarPacientes(provider);

                if (pacientes.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_alt_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text('Nenhum paciente encontrado'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: pacientes.length,
                  itemBuilder: (context, index) {
                    final p = pacientes[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: p.isPrioritario()
                              ? Colors.red
                              : Colors.green,
                          child: Text(
                            p.nome[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(p.nome),
                        subtitle: Text(
                          '${p.getIdade()} anos | ${p.microarea} | ${p.cpf}',
                        ),
                        trailing: p.isPrioritario()
                            ? const Icon(Icons.warning, color: Colors.red)
                            : null,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/paciente',
                            arguments: p.id,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    return FilterChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      selected: _filtroAtual == value,
      onSelected: (selected) {
        setState(() {
          _filtroAtual = value;
        });
      },
      selectedColor: Colors.green.shade100,
      checkmarkColor: Colors.green,
    );
  }

  List<Paciente> _filtrarPacientes(PacienteProvider provider) {
    switch (_filtroAtual) {
      case 'diabeticos':
        return provider.getDiabeticos();
      case 'hipertensos':
        return provider.getHipertensos();
      case 'preventivo':
        return provider.getMulheresSemPreventivo();
      case 'criancas':
        return provider.getCriancasCadernetaAtrasada();
      case 'vasectomia':
        return provider.getHomensInteresseVasectomia();
      case 'acamados':
        return provider.getAcamados();
      case 'prioritarios':
        return provider.getPrioritarios();
      default:
        return provider.pacientes;
    }
  }
}
