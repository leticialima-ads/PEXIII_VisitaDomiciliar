import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/paciente.dart';
import '../models/visita_domiciliar.dart';
import '../models/metodo_contraceptivo.dart';
import '../providers/paciente_provider.dart';

class VisitaScreen extends StatefulWidget {
  const VisitaScreen({super.key});

  @override
  State<VisitaScreen> createState() => _VisitaScreenState();
}

class _VisitaScreenState extends State<VisitaScreen> {
  Paciente? _pacienteSelecionado;
  DateTime _data = DateTime.now();
  final _motivoController = TextEditingController();
  final _observacoesController = TextEditingController();
  bool _acamado = false;

  bool _diabetes = false;
  DateTime? _dataConsultaDiabetes;

  bool _hipertensao = false;
  DateTime? _dataConsultaHipertensao;

  bool _preventivoEmDia = true;
  DateTime? _dataUltimoPreventivo;
  MetodoContraceptivo? _metodoContraceptivo;

  bool _cadernetaEmDia = true;

  bool _interesseVasectomia = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PacienteProvider>(context);
    final pacientes = provider.pacientes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Visita'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<Paciente>(
            decoration: const InputDecoration(
              labelText: 'Selecione o Paciente',
              border: OutlineInputBorder(),
            ),
            value: _pacienteSelecionado,
            items: pacientes.map((p) {
              return DropdownMenuItem(
                value: p,
                child: Text('${p.nome} (${p.getIdade()} anos)'),
              );
            }).toList(),
            onChanged: (value) => setState(() => _pacienteSelecionado = value),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _data,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) setState(() => _data = date);
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Data da visita',
                border: OutlineInputBorder(),
              ),
              child: Text('${_data.day}/${_data.month}/${_data.year}'),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _motivoController,
            decoration: const InputDecoration(
              labelText: 'Motivo da visita',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _observacoesController,
            decoration: const InputDecoration(
              labelText: 'Observações',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Paciente acamado'),
            value: _acamado,
            onChanged: (value) => setState(() => _acamado = value),
          ),
          const Divider(),
          const Text(
            'Informações de Saúde',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Diabetes'),
            value: _diabetes,
            onChanged: (value) => setState(() => _diabetes = value),
          ),
          if (_diabetes)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null)
                    setState(() => _dataConsultaDiabetes = date);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data última consulta diabetes',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _dataConsultaDiabetes != null
                        ? '${_dataConsultaDiabetes!.day}/${_dataConsultaDiabetes!.month}/${_dataConsultaDiabetes!.year}'
                        : 'Selecione a data',
                  ),
                ),
              ),
            ),
          SwitchListTile(
            title: const Text('Hipertensão'),
            value: _hipertensao,
            onChanged: (value) => setState(() => _hipertensao = value),
          ),
          if (_hipertensao)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null)
                    setState(() => _dataConsultaHipertensao = date);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data última consulta hipertensão',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _dataConsultaHipertensao != null
                        ? '${_dataConsultaHipertensao!.day}/${_dataConsultaHipertensao!.month}/${_dataConsultaHipertensao!.year}'
                        : 'Selecione a data',
                  ),
                ),
              ),
            ),
          if (_pacienteSelecionado != null &&
              _pacienteSelecionado!.isMenorDeSeis()) ...[
            const Divider(),
            const Text(
              'Saúde da Criança',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Caderneta de vacinação em dia'),
              value: _cadernetaEmDia,
              onChanged: (value) => setState(() => _cadernetaEmDia = value),
            ),
          ],
          if (_pacienteSelecionado != null &&
              _pacienteSelecionado!.isMulherIdadeFertil()) ...[
            const Divider(),
            const Text(
              'Saúde da Mulher',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Preventivo em dia'),
              value: _preventivoEmDia,
              onChanged: (value) => setState(() => _preventivoEmDia = value),
            ),
            if (!_preventivoEmDia) ...[
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null)
                      setState(() => _dataUltimoPreventivo = date);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Data do último preventivo',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _dataUltimoPreventivo != null
                          ? '${_dataUltimoPreventivo!.day}/${_dataUltimoPreventivo!.month}/${_dataUltimoPreventivo!.year}'
                          : 'Selecione a data',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: DropdownButtonFormField<MetodoContraceptivo>(
                  decoration: const InputDecoration(
                    labelText: 'Método contraceptivo',
                    border: OutlineInputBorder(),
                  ),
                  value: _metodoContraceptivo,
                  items: MetodoContraceptivo.valores.map((metodo) {
                    return DropdownMenuItem(
                      value: metodo,
                      child: Text(metodo.descricao),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _metodoContraceptivo = value),
                ),
              ),
            ],
          ],
          if (_pacienteSelecionado != null &&
              _pacienteSelecionado!.isHomemIdadeVasectomia()) ...[
            const Divider(),
            const Text(
              'Planejamento Familiar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Interesse em vasectomia'),
              value: _interesseVasectomia,
              onChanged: (value) =>
                  setState(() => _interesseVasectomia = value),
            ),
          ],
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _salvar,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Registrar Visita',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _salvar() async {
    if (_pacienteSelecionado == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione um paciente')));
      return;
    }

    final visita = VisitaDomiciliar(
      pacienteId: _pacienteSelecionado!.id!,
      data: _data,
      motivo: _motivoController.text,
      observacoes: _observacoesController.text,
      acamado: _acamado,
      diabetes: _diabetes,
      dataConsultaDiabetes: _dataConsultaDiabetes,
      hipertensao: _hipertensao,
      dataConsultaHipertensao: _dataConsultaHipertensao,
      preventivoEmDia: _preventivoEmDia,
      dataUltimoPreventivo: _dataUltimoPreventivo,
      metodoContraceptivo: _metodoContraceptivo,
      cadernetaEmDia: _cadernetaEmDia,
      interesseVasectomia: _interesseVasectomia,
    );

    final provider = Provider.of<PacienteProvider>(context, listen: false);
    await provider.registrarVisita(visita);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Visita registrada com sucesso!')),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _motivoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }
}
