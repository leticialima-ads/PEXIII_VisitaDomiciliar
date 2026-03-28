import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/paciente_provider.dart';
import 'screens/home_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/visita_screen.dart';
import 'screens/relatorio_screen.dart';
import 'screens/listagem_screen.dart';
import 'screens/filtros_screen.dart';
import 'screens/pa_screen.dart';
import 'screens/paciente_detail_screen.dart';
import 'screens/editar_paciente_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PacienteProvider())],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 2,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/cadastro': (context) => const CadastroScreen(),
          '/visita': (context) => const VisitaScreen(),
          '/relatorios': (context) => const RelatorioScreen(),
          '/listagem': (context) => const ListagemScreen(),
          '/filtros': (context) => const FiltrosScreen(),
          '/pa': (context) => const PAScreen(),
          '/paciente': (context) => PacienteDetailScreen(
            pacienteId: ModalRoute.of(context)!.settings.arguments as int,
          ),
          '/editar': (context) => EditarPacienteScreen(
            pacienteId: ModalRoute.of(context)!.settings.arguments as int,
          ),
        },
      ),
    );
  }
}
