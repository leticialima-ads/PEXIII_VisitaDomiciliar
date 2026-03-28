import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/paciente_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      appBar: AppBar(title: const Text('Sistema ACS'), centerTitle: true),
      drawer: _buildDrawer(),
      body: Consumer<PacienteProvider>(
        builder: (context, provider, child) {
          final pacientes = provider.pacientes;
          final prioritarios = provider.getPrioritarios();

          return RefreshIndicator(
            onRefresh: () => provider.carregarPacientes(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total',
                        pacientes.length.toString(),
                        Colors.blue,
                        Icons.people,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Prioritários',
                        prioritarios.length.toString(),
                        Colors.red,
                        Icons.warning,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Microáreas',
                        pacientes
                            .map((p) => p.microarea)
                            .toSet()
                            .length
                            .toString(),
                        Colors.green,
                        Icons.map,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'PRIORITÁRIOS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                if (prioritarios.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('Nenhum paciente prioritário no momento'),
                    ),
                  )
                else
                  ...prioritarios.take(5).map((p) => _buildPacienteCard(p)),
                if (prioritarios.length > 5)
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/filtros');
                    },
                    child: Text('Ver todos (${prioritarios.length})'),
                  ),
              ],
            ),
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

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Sistema ACS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Busca Ativa em Saúde Pública',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Cadastrar Paciente'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/cadastro');
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_work),
            title: const Text('Registrar Visita'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/visita');
            },
          ),
          ListTile(
            leading: const Icon(Icons.filter_alt),
            title: const Text('Filtros'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/filtros');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Relatórios'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/relatorios');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildPacienteCard(p) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red,
          child: Text(
            p.nome[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          p.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${p.getIdade()} anos | ${p.microarea}'),
        trailing: const Icon(Icons.warning, color: Colors.red),
        onTap: () {
          Navigator.pushNamed(context, '/paciente', arguments: p.id);
        },
      ),
    );
  }
}
