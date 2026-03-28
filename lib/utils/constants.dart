import 'package:flutter/material.dart';

class AppConstants {
  // Cores principais
  static const Color primaryColor = Colors.green;
  static const Color secondaryColor = Colors.blue;
  static const Color warningColor = Colors.orange;
  static const Color dangerColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color infoColor = Colors.blue;
  static const Color backgroundColor = Color(0xFFF5F5F5);

  // Strings do App
  static const String appName = 'Sistema ACS';
  static const String appVersion = 'PEX III v1.0';
  static const String appDescription =
      'Sistema de Estratificação Territorial para Busca Ativa em Saúde Pública';

  // Mensagens de sucesso
  static const String msgCadastroSucesso = 'Paciente cadastrado com sucesso!';
  static const String msgAtualizacaoSucesso = 'Dados atualizados com sucesso!';
  static const String msgExclusaoSucesso = 'Paciente excluído com sucesso!';
  static const String msgVisitaSucesso = 'Visita registrada com sucesso!';
  static const String msgPASucesso = 'Pressão Arterial registrada com sucesso!';

  // Mensagens de erro
  static const String msgErroConexao = 'Erro ao conectar com o banco de dados';
  static const String msgErroCadastro = 'Erro ao cadastrar paciente';
  static const String msgErroExclusao = 'Erro ao excluir paciente';
  static const String msgCamposObrigatorios =
      'Preencha todos os campos obrigatórios';
  static const String msgPacienteNaoEncontrado = 'Paciente não encontrado';
  static const String msgDataInvalida = 'Data inválida';

  // Mensagens de confirmação
  static const String msgConfirmarExclusao =
      'Tem certeza que deseja excluir este paciente?';
  static const String msgConfirmarCancelar = 'Deseja cancelar esta operação?';

  // Valores padrão
  static const int idadeMinimaCrianca = 6;
  static const int idadeMinimaMulherFertil = 25;
  static const int idadeMaximaMulherFertil = 64;
  static const int idadeMinimaHomemVasectomia = 25;
  static const int idadeMaximaHomemVasectomia = 64;
  static const int diasAtrasoConsulta = 30;
  static const int diasAtrasoPreventivo = 365;
  static const int diasAtrasoVacina = 180;

  // Categorias de PA
  static const Map<String, String> classificacaoPA = {
    'normal': 'Normal (<120/80)',
    'elevada': 'Elevada (120-129/<80)',
    'estagio1': 'Hipertensão Estágio 1 (130-139/80-89)',
    'estagio2': 'Hipertensão Estágio 2 (140-159/90-99)',
    'crise': 'Hipertensão Estágio 3 (>160/>100)',
  };

  // Cores para classificação de PA
  static const Map<String, Color> coresClassificacaoPA = {
    'normal': Colors.green,
    'elevada': Colors.orange,
    'estagio1': Colors.orange,
    'estagio2': Colors.red,
    'crise': Colors.red,
  };

  // Filtros disponíveis
  static const List<Map<String, dynamic>> filtros = [
    {
      'id': 'todos',
      'nome': 'Todos',
      'icon': Icons.people,
      'color': Colors.blue,
    },
    {
      'id': 'diabeticos',
      'nome': 'Diabéticos',
      'icon': Icons.bloodtype,
      'color': Colors.orange,
    },
    {
      'id': 'hipertensos',
      'nome': 'Hipertensos',
      'icon': Icons.favorite,
      'color': Colors.red,
    },
    {
      'id': 'preventivo',
      'nome': 'Mulheres sem Preventivo',
      'icon': Icons.woman,
      'color': Colors.pink,
    },
    {
      'id': 'criancas',
      'nome': 'Crianças Caderneta Atrasada',
      'icon': Icons.child_care,
      'color': Colors.purple,
    },
    {
      'id': 'vasectomia',
      'nome': 'Interesse Vasectomia',
      'icon': Icons.male,
      'color': Colors.teal,
    },
    {
      'id': 'acamados',
      'nome': 'Acamados',
      'icon': Icons.bed,
      'color': Colors.grey,
    },
    {
      'id': 'prioritarios',
      'nome': 'Prioritários',
      'icon': Icons.warning,
      'color': Colors.red,
    },
  ];

  // Opções de sexo
  static const List<Map<String, String>> opcoesSexo = [
    {'value': 'MASCULINO', 'label': 'Masculino'},
    {'value': 'FEMININO', 'label': 'Feminino'},
  ];

  // Métodos contraceptivos
  static const List<String> metodosContraceptivos = [
    'Nenhum',
    'Pílula',
    'Injetável',
    'DIU',
    'Implante',
    'Adesivo',
    'Anel vaginal',
    'Preservativo',
    'Laqueadura',
    'Vasectomia',
  ];

  // Opções de filtro de data
  static const List<Map<String, String>> opcoesFiltroData = [
    {'value': 'hoje', 'label': 'Hoje'},
    {'value': 'semana', 'label': 'Esta semana'},
    {'value': 'mes', 'label': 'Este mês'},
    {'value': 'ano', 'label': 'Este ano'},
    {'value': 'todos', 'label': 'Todos'},
  ];

  // Abas do detalhe do paciente
  static const List<Map<String, dynamic>> tabsPaciente = [
    {'label': 'Dados', 'icon': Icons.person},
    {'label': 'PA', 'icon': Icons.favorite},
    {'label': 'Visitas', 'icon': Icons.history},
  ];

  // Tamanhos de fonte
  static const double fontSizeSmall = 12;
  static const double fontSizeMedium = 14;
  static const double fontSizeLarge = 16;
  static const double fontSizeExtraLarge = 18;
  static const double fontSizeTitle = 20;
  static const double fontSizeBig = 24;

  // Espaçamentos
  static const double spacingSmall = 4;
  static const double spacingMedium = 8;
  static const double spacingLarge = 12;
  static const double spacingExtraLarge = 16;
  static const double spacingBig = 24;
  static const double spacingHuge = 32;

  // Bordas
  static const double borderRadiusSmall = 4;
  static const double borderRadiusMedium = 8;
  static const double borderRadiusLarge = 12;
  static const double borderRadiusExtraLarge = 16;
  static const double borderRadiusCircle = 50;
}
