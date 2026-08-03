import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/paciente.dart';
import '../providers/paciente_provider.dart';
import '../utils/date_utils_helper.dart';

class ListagemScreen extends StatelessWidget {
  const ListagemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Listagem de Pacientes',
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: Consumer<PacienteProvider>(
        builder: (
          context,
          provider,
          child,
        ) {
          final pacientes =
              provider.pacientes;

          if (pacientes.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum paciente cadastrado',
              ),
            );
          }

          return ListView.builder(
            itemCount: pacientes.length,

            itemBuilder: (
              context,
              index,
            ) {
              return _buildPacienteCard(
                context,
                pacientes[index],
              );
            },
          );
        },
      ),
    );
  }

  // =====================================================
  // CARD DO PACIENTE
  // =====================================================

  Widget _buildPacienteCard(
    BuildContext context,
    Paciente paciente,
  ) {
    final ultimaVisita =
        paciente.getUltimaVisita();

    return Card(
      margin:
          const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),

      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor:
              paciente.isPrioritario()
                  ? Colors.red
                  : Colors.green,

          child: Text(
            paciente.nome.isNotEmpty
                ? paciente.nome[0]
                    .toUpperCase()
                : '?',

            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),

        title: Text(
          paciente.nome,

          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        subtitle: Text(
          '${paciente.getIdade()} anos | ${paciente.microarea}',
        ),

        trailing:
            paciente.isPrioritario()
                ? const Icon(
                    Icons.warning,
                    color: Colors.red,
                  )
                : null,

        children: [
          Padding(
            padding:
                const EdgeInsets.all(
                  12,
                ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                const Divider(),

                _buildInfoRow(
                  'CPF',
                  paciente.cpf,
                ),

                _buildInfoRow(
                  'Data Nascimento',
                  _formatDate(
                    paciente
                        .dataNascimento,
                  ),
                ),

                _buildInfoRow(
                  'Idade',
                  '${paciente.getIdade()} anos',
                ),

                _buildInfoRow(
                  'Sexo',
                  paciente.sexo ==
                          'MASCULINO'
                      ? 'Masculino'
                      : 'Feminino',
                ),

                _buildInfoRow(
                  'Microárea',
                  paciente.microarea,
                ),

                _buildInfoRow(
                  'Endereço',
                  paciente.endereco,
                ),

                if (ultimaVisita !=
                    null) ...[
                  const SizedBox(
                    height: 8,
                  ),

                  _buildInfoRow(
                    'Última visita',
                    _formatDate(
                      ultimaVisita.data,
                    ),
                  ),

                  _buildInfoRow(
                    'Motivo',
                    ultimaVisita.motivo,
                  ),
                ],

                if (paciente
                    .isPrioritario()) ...[
                  const SizedBox(
                    height: 8,
                  ),

                  Container(
                    padding:
                        const EdgeInsets.all(
                          8,
                        ),

                    decoration:
                        BoxDecoration(
                          color: Colors
                              .red
                              .shade50,

                          borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                        ),

                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning,
                          color:
                              Colors.red,
                          size: 20,
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        Expanded(
                          child: Text(
                            'PRIORITÁRIO: ${paciente.getPrioridadeDescricao()}',

                            style:
                                const TextStyle(
                                  color:
                                      Colors.red,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(
                  height: 12,
                ),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .end,

                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/visita',
                          arguments:
                              paciente.id,
                        );
                      },

                      icon: const Icon(
                        Icons.home_work,
                      ),

                      label: const Text(
                        'Visita',
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/paciente',
                          arguments:
                              paciente.id,
                        );
                      },

                      icon: const Icon(
                        Icons.visibility,
                      ),

                      label: const Text(
                        'Detalhes',
                      ),
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

  // =====================================================
  // LINHA DE INFORMAÇÃO
  // =====================================================

  Widget _buildInfoRow(
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
            vertical: 2,
          ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 130,

            child: Text(
              '$label:',

              style: const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // FORMATAÇÃO DE DATA
  // =====================================================

  String _formatDate(DateTime date) {
    return DateUtilsHelper.formatDate(
      date,
    );
  }
}

