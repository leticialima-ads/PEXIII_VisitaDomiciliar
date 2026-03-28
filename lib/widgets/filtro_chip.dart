import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FiltroChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const FiltroChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? Colors.white : Colors.grey[600],
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontSize: 13,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.grey[200],
      selectedColor: AppConstants.primaryColor,
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: isSelected ? Colors.transparent : Colors.grey[300]!,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }
}

// Grupo de filtros (vários chips)
class FiltroChipGroup extends StatefulWidget {
  final List<Map<String, dynamic>> filtros;
  final Function(String) onFilterChanged;
  final String initialFilter;

  const FiltroChipGroup({
    super.key,
    required this.filtros,
    required this.onFilterChanged,
    required this.initialFilter,
  });

  @override
  State<FiltroChipGroup> createState() => _FiltroChipGroupState();
}

class _FiltroChipGroupState extends State<FiltroChipGroup> {
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.filtros.map((filtro) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FiltroChip(
              label: filtro['nome'],
              icon: filtro['icon'],
              isSelected: _selectedFilter == filtro['id'],
              onTap: () {
                setState(() {
                  _selectedFilter = filtro['id'];
                });
                widget.onFilterChanged(_selectedFilter);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Filtro de status (Sim/Não)
class StatusFiltroChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const StatusFiltroChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppConstants.primaryColor,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
      ),
    );
  }
}

// Filtro de data
class DateFiltroChip extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const DateFiltroChip({
    super.key,
    required this.label,
    this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;

    return ActionChip(
      avatar: Icon(
        hasDate ? Icons.calendar_today : Icons.calendar_month,
        size: 16,
        color: hasDate ? AppConstants.primaryColor : Colors.grey[600],
      ),
      label: Text(
        hasDate ? _formatDate(date!) : label,
        style: TextStyle(
          color: hasDate ? AppConstants.primaryColor : Colors.grey[700],
        ),
      ),
      onPressed: onTap,
      backgroundColor: hasDate
          ? AppConstants.primaryColor.withOpacity(0.1)
          : Colors.grey[200],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Filtro de período
class PeriodoFiltroChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PeriodoFiltroChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppConstants.primaryColor,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
      ),
    );
  }
}

// Grupo de filtros de período
class PeriodoFiltroGroup extends StatefulWidget {
  final Function(String) onPeriodoChanged;
  final String initialPeriodo;

  const PeriodoFiltroGroup({
    super.key,
    required this.onPeriodoChanged,
    required this.initialPeriodo,
  });

  @override
  State<PeriodoFiltroGroup> createState() => _PeriodoFiltroGroupState();
}

class _PeriodoFiltroGroupState extends State<PeriodoFiltroGroup> {
  late String _selectedPeriodo;

  final List<Map<String, String>> _periodos = [
    {'value': 'hoje', 'label': 'Hoje'},
    {'value': 'semana', 'label': 'Esta semana'},
    {'value': 'mes', 'label': 'Este mês'},
    {'value': 'ano', 'label': 'Este ano'},
    {'value': 'todos', 'label': 'Todos'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedPeriodo = widget.initialPeriodo;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _periodos.map((periodo) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PeriodoFiltroChip(
              label: periodo['label']!,
              isSelected: _selectedPeriodo == periodo['value'],
              onTap: () {
                setState(() {
                  _selectedPeriodo = periodo['value']!;
                });
                widget.onPeriodoChanged(_selectedPeriodo);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
