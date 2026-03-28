import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../utils/date_utils.dart';
import '../utils/constants.dart';

class PacienteCard extends StatelessWidget {
  final Paciente paciente;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onVisita;
  final VoidCallback? onDetalhes;
  final bool showActions;

  const PacienteCard({
    super.key,
    required this.paciente,
    this.onTap,
    this.onDelete,
    this.onVisita,
    this.onDetalhes,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final isPrioritario = paciente.isPrioritario();
    final idade = paciente.getIdade();
    final ultimaVisita = paciente.getUltimaVisita();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isPrioritario
                ? Border.all(color: AppConstants.dangerColor, width: 1.5)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Row(
                children: [
                  _buildAvatar(idade, isPrioritario, paciente.sexo),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paciente.nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${idade} anos | ${paciente.microarea}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isPrioritario)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'PRIORITÁRIO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Informações de saúde (chips)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (ultimaVisita != null && ultimaVisita.diabetes)
                    _buildHealthChip(
                      'Diabetes',
                      Icons.bloodtype,
                      ultimaVisita.isConsultaDiabetesAtrasada()
                          ? Colors.red
                          : Colors.orange,
                    ),
                  if (ultimaVisita != null && ultimaVisita.hipertensao)
                    _buildHealthChip(
                      'Hipertensão',
                      Icons.favorite,
                      ultimaVisita.isConsultaHipertensaoAtrasada()
                          ? Colors.red
                          : Colors.orange,
                    ),
                  if (paciente.isMenorDeSeis())
                    _buildHealthChip(
                      'Criança',
                      Icons.child_care,
                      (ultimaVisita != null && !ultimaVisita.cadernetaEmDia)
                          ? Colors.red
                          : Colors.green,
                    ),
                  if (paciente.isMulherIdadeFertil() &&
                      ultimaVisita != null &&
                      !ultimaVisita.preventivoEmDia)
                    _buildHealthChip(
                      'Preventivo atrasado',
                      Icons.woman,
                      Colors.red,
                    ),
                  if (ultimaVisita != null && ultimaVisita.acamado)
                    _buildHealthChip('Acamado', Icons.bed, Colors.red),
                  if (ultimaVisita != null && ultimaVisita.interesseVasectomia)
                    _buildHealthChip(
                      'Interesse vasectomia',
                      Icons.male,
                      Colors.blue,
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Botões de ação
              if (showActions)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onVisita != null)
                      _buildActionButton(
                        icon: Icons.home_work,
                        label: 'Visita',
                        onPressed: onVisita!,
                        color: Colors.blue,
                      ),
                    if (onDetalhes != null)
                      _buildActionButton(
                        icon: Icons.visibility,
                        label: 'Detalhes',
                        onPressed: onDetalhes!,
                        color: Colors.green,
                      ),
                    if (onDelete != null)
                      _buildActionButton(
                        icon: Icons.delete,
                        label: 'Excluir',
                        onPressed: onDelete!,
                        color: Colors.red,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(int idade, bool isPrioritario, String sexo) {
    Color bgColor;
    if (isPrioritario) {
      bgColor = Colors.red;
    } else if (idade < 6) {
      bgColor = Colors.orange;
    } else if (idade > 60) {
      bgColor = Colors.blue;
    } else {
      bgColor = Colors.green;
    }

    return CircleAvatar(
      backgroundColor: bgColor,
      radius: 28,
      child: Text(
        _getAvatarText(sexo, idade),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getAvatarText(String sexo, int idade) {
    if (sexo == 'MASCULINO') {
      if (idade < 6) return '👶';
      if (idade < 18) return '👦';
      return '👨';
    } else {
      if (idade < 6) return '👶';
      if (idade < 18) return '👧';
      return '👩';
    }
  }

  Widget _buildHealthChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(label, style: TextStyle(fontSize: 12, color: color)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

// Card de resumo de paciente (versão simplificada)
class PacienteCardResumo extends StatelessWidget {
  final Paciente paciente;
  final VoidCallback onTap;

  const PacienteCardResumo({
    super.key,
    required this.paciente,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final idade = paciente.getIdade();

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: paciente.isPrioritario() ? Colors.red : Colors.green,
        child: Text(
          paciente.nome[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(paciente.nome),
      subtitle: Text('${idade} anos | ${paciente.microarea}'),
      trailing: paciente.isPrioritario()
          ? const Icon(Icons.warning, color: Colors.red)
          : null,
      onTap: onTap,
    );
  }
}

// Card de paciente prioritário (destaque)
class PacientePrioritarioCard extends StatelessWidget {
  final Paciente paciente;
  final VoidCallback onTap;

  const PacientePrioritarioCard({
    super.key,
    required this.paciente,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ultimaVisita = paciente.getUltimaVisita();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: Colors.red.shade50,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      paciente.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '${paciente.getIdade()} anos',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                paciente.getPrioridadeDescricao(),
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
              if (ultimaVisita != null && ultimaVisita.acamado)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    '⚠️ Paciente acamado',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Card de paciente hipertenso (para registro de PA)
class PacienteHipertensoCard extends StatelessWidget {
  final Paciente paciente;
  final VoidCallback onTap;

  const PacienteHipertensoCard({
    super.key,
    required this.paciente,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(Icons.favorite, color: Colors.white),
        ),
        title: Text(paciente.nome),
        subtitle: Text('${paciente.getIdade()} anos | ${paciente.microarea}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
