import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/paciente.dart';
import '../providers/paciente_provider.dart';

class EditarPacienteScreen extends StatefulWidget {
  final int pacienteId;

  const EditarPacienteScreen({
    super.key,
    required this.pacienteId,
  });

  @override
  State<EditarPacienteScreen> createState() =>
      _EditarPacienteScreenState();
}

class _EditarPacienteScreenState
    extends State<EditarPacienteScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _microareaController =
      TextEditingController();
  final _enderecoController =
      TextEditingController();

  DateTime? _dataNascimento;
  String? _sexo;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarPaciente();
  }

  Future<void> _carregarPaciente() async {
    final provider =
        Provider.of<PacienteProvider>(
      context,
      listen: false,
    );

    await provider.carregarPacientes();

    final pacientes = provider.pacientes.where(
      (p) => p.id == widget.pacienteId,
    );

    if (pacientes.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Paciente não encontrado.',
          ),
        ),
      );

      Navigator.pop(context);
      return;
    }

    final paciente = pacientes.first;

    _nomeController.text = paciente.nome;
    _cpfController.text = paciente.cpf;
    _microareaController.text =
        paciente.microarea;
    _enderecoController.text =
        paciente.endereco;

    _dataNascimento =
        paciente.dataNascimento;
    _sexo = paciente.sexo;

    if (!mounted) return;

    setState(
      () => _isLoading = false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Paciente',
        ),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding:
                    const EdgeInsets.all(16),
                children: [
                  _buildSectionTitle(
                    'Dados Pessoais',
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller:
                        _nomeController,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Nome completo',
                      border:
                          OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value
                              .trim()
                              .isEmpty) {
                        return 'Campo obrigatório';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  InkWell(
                    onTap: () =>
                        _selectDate(
                            context),
                    child:
                        InputDecorator(
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Data de Nascimento',
                        border:
                            OutlineInputBorder(),
                      ),
                      child: Text(
                        _dataNascimento !=
                                null
                            ? _formatDate(
                                _dataNascimento!,
                              )
                            : 'Selecione a data',
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<
                      String>(
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Sexo',
                      border:
                          OutlineInputBorder(),
                    ),
                    value: _sexo,
                    items: const [
                      DropdownMenuItem(
                        value:
                            'MASCULINO',
                        child: Text(
                          'Masculino',
                        ),
                      ),
                      DropdownMenuItem(
                        value:
                            'FEMININO',
                        child: Text(
                          'Feminino',
                        ),
                      ),
                    ],
                    onChanged:
                        (value) {
                      setState(
                        () => _sexo =
                            value,
                      );
                    },
                    validator:
                        (value) {
                      if (value ==
                          null) {
                        return 'Campo obrigatório';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller:
                        _cpfController,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'CPF',
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller:
                        _microareaController,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Microárea (ex: A1, B3)',
                      border:
                          OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value
                              .trim()
                              .isEmpty) {
                        return 'Campo obrigatório';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller:
                        _enderecoController,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Endereço',
                      border:
                          OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value
                              .trim()
                              .isEmpty) {
                        return 'Campo obrigatório';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child:
                            ElevatedButton(
                          onPressed:
                              _salvar,
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.green,
                            padding:
                                const EdgeInsets.symmetric(
                              vertical:
                                  16,
                            ),
                          ),
                          child:
                              const Text(
                            'Salvar',
                            style:
                                TextStyle(
                              color: Colors
                                  .white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 16,
                      ),

                      Expanded(
                        child:
                            OutlinedButton(
                          onPressed:
                              () =>
                                  Navigator.pop(
                            context,
                          ),
                          style:
                              OutlinedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(
                              vertical:
                                  16,
                            ),
                          ),
                          child:
                              const Text(
                            'Cancelar',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(
    String title,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight:
              FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
  ) async {
    final date =
        await showDatePicker(
      context: context,
      initialDate:
          _dataNascimento ??
              DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(
        () =>
            _dataNascimento =
                date,
      );
    }
  }

  String _formatDate(
    DateTime date,
  ) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    if (_dataNascimento ==
            null ||
        _sexo == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Preencha data de nascimento e sexo',
          ),
        ),
      );

      return;
    }

    final paciente = Paciente(
      id: widget.pacienteId,
      nome: _nomeController.text
          .trim(),
      dataNascimento:
          _dataNascimento!,
      sexo: _sexo!,
      cpf: _cpfController.text
              .trim()
              .isEmpty
          ? 'NAO POSSUI'
          : _cpfController.text
              .trim(),
      microarea:
          _microareaController.text
              .trim(),
      endereco:
          _enderecoController.text
              .trim(),
    );

    final provider =
        Provider.of<PacienteProvider>(
      context,
      listen: false,
    );

    await provider
        .atualizarPaciente(
      paciente,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Paciente atualizado com sucesso!',
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _microareaController.dispose();
    _enderecoController.dispose();

    super.dispose();
  }
}
