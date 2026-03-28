import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/paciente_provider.dart';

class RelatorioScreen extends StatelessWidget {
  const RelatorioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        backgroundColor: Colors.green,
      ),
      body: Consumer<PacienteProvider>(
        builder: (context, provider, child) {
          final diabeticos = provider.getDiabeticos();
          final hipertensos = provider.getHipertensos();
          final mulheres = provider.getMulheresSemPreventivo();
          final criancas = provider.getCriancasCadernetaAtrasada();
          final homens = provider.getHomensInteresseVasectomia();
          final acamados = provider.getAcamados();
          final prioritarios = provider.getPrioritarios();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildCard(
                'Diabéticos',
                diabeticos.length,
                Colors.orange,
                Icons.bloodtype,
                diabeticos,
              ),
              _buildCard(
                'Hipertensos',
                hipertensos.length,
                Colors.red,
                Icons.favorite,
                hipertensos,
              ),
              _buildCard(
                'Mulheres sem Preventivo',
                mulheres.length,
                Colors.pink,
                Icons.woman,
                mulheres,
              ),
              _buildCard(
                'Crianças Caderneta Atrasada',
                criancas.length,
                Colors.purple,
                Icons.child_care,
                criancas,
              ),
              _buildCard(
                'Homens Interesse Vasectomia',
                homens.length,
                Colors.teal,
                Icons.male,
                homens,
              ),
              _buildCard(
                'Acamados',
                acamados.length,
                Colors.grey,
                Icons.bed,
                acamados,
              ),
              _buildCard(
                'Prioritários',
                prioritarios.length,
                Colors.red,
                Icons.warning,
                prioritarios,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(
    String title,
    int count,
    Color color,
    IconData icon,
    List pacientes,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        children: pacientes.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Nenhum paciente encontrado'),
                ),
              ]
            : pacientes
                  .map<Widget>(
                    (p) => ListTile(
                      title: Text(p.nome),
                      subtitle: Text(
                        '${p.getIdade()} anos | ${p.microarea} | ${p.cpf}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/paciente',
                          arguments: p.id,
                        );
                      },
                    ),
                  )
                  .toList(),
      ),
    );
  }
}
