import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../models/paciente.dart';
import '../models/visita_domiciliar.dart';
import '../models/metodo_contraceptivo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();

    final path = join(
      directory.path,
      'saude_acs.db',
    );

    return openDatabase(
      path,
      version: 1,

      onConfigure: (db) async {
        await db.execute(
          'PRAGMA foreign_keys = ON',
        );
      },

      onCreate: _onCreate,

      onUpgrade: (db, oldVersion, newVersion) async {
        // Futuras alterações do banco
      },
    );
  }

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    // ==================== PACIENTES ====================

    await db.execute('''
      CREATE TABLE pacientes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        data_nascimento TEXT NOT NULL,
        sexo TEXT NOT NULL,
        cpf TEXT NOT NULL UNIQUE,
        microarea TEXT NOT NULL,
        endereco TEXT NOT NULL
      )
    ''');

    // ==================== VISITAS ====================

    await db.execute('''
      CREATE TABLE visitas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        paciente_id INTEGER NOT NULL,
        data TEXT NOT NULL,
        motivo TEXT NOT NULL,
        observacoes TEXT,
        acamado INTEGER,
        diabetes INTEGER,
        data_consulta_diabetes TEXT,
        hipertensao INTEGER,
        data_consulta_hipertensao TEXT,
        preventivo_em_dia INTEGER,
        data_ultimo_preventivo TEXT,
        metodo_contraceptivo TEXT,
        caderneta_em_dia INTEGER,
        interesse_vasectomia INTEGER,

        FOREIGN KEY(paciente_id)
        REFERENCES pacientes(id)
        ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_visitas_paciente
      ON visitas(paciente_id)
    ''');
  }

  // ==================== PACIENTES ====================

  Future<int> insertPaciente(
    Paciente paciente,
  ) async {
    final db = await database;

    return db.insert(
      'pacientes',
      paciente.toMap(),
    );
  }

  Future<List<Paciente>> getAllPacientes() async {
    final db = await database;

    final maps = await db.query(
      'pacientes',
    );

    return maps
        .map((e) => Paciente.fromMap(e))
        .toList();
  }

  Future<Paciente?> getPacienteById(
    int id,
  ) async {
    final db = await database;

    final maps = await db.query(
      'pacientes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return Paciente.fromMap(
      maps.first,
    );
  }

  Future<int> updatePaciente(
    Paciente paciente,
  ) async {
    final db = await database;

    return db.update(
      'pacientes',
      paciente.toMap(),
      where: 'id = ?',
      whereArgs: [paciente.id],
    );
  }

  Future<int> deletePaciente(
    int id,
  ) async {
    final db = await database;

    return db.delete(
      'pacientes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== VISITAS ====================

  Future<int> insertVisita(
    VisitaDomiciliar visita,
  ) async {
    final db = await database;

    return db.insert(
      'visitas',
      visita.toMap(),
    );
  }

  Future<List<VisitaDomiciliar>> getAllVisitas() async {
    final db = await database;

    final maps = await db.query(
      'visitas',
      orderBy: 'data DESC',
    );

    return maps
        .map((e) => VisitaDomiciliar.fromMap(e))
        .toList();
  }

  Future<List<VisitaDomiciliar>> getVisitasByPaciente(
    int pacienteId,
  ) async {
    final db = await database;

    final maps = await db.query(
      'visitas',
      where: 'paciente_id = ?',
      whereArgs: [pacienteId],
      orderBy: 'data DESC',
    );

    return maps
        .map((e) => VisitaDomiciliar.fromMap(e))
        .toList();
  }

  Future<VisitaDomiciliar?> getUltimaVisita(
    int pacienteId,
  ) async {
    final db = await database;

    final maps = await db.query(
      'visitas',
      where: 'paciente_id = ?',
      whereArgs: [pacienteId],
      orderBy: 'data DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;

    return VisitaDomiciliar.fromMap(
      maps.first,
    );
  }

  Future<int> updateVisita(
    VisitaDomiciliar visita,
  ) async {
    final db = await database;

    return db.update(
      'visitas',
      visita.toMap(),
      where: 'id = ?',
      whereArgs: [visita.id],
    );
  }

  Future<int> deleteVisita(
    int id,
  ) async {
    final db = await database;

    return db.delete(
      'visitas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== RELATÓRIOS ====================

  Future<int> getCountDiabeticos() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT COUNT(DISTINCT paciente_id) as total
      FROM visitas
      WHERE diabetes = 1
    ''');

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getCountHipertensos() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT COUNT(DISTINCT paciente_id) as total
      FROM visitas
      WHERE hipertensao = 1
    ''');

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getCountAcamados() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT COUNT(DISTINCT paciente_id) as total
      FROM visitas
      WHERE acamado = 1
    ''');

    return Sqflite.firstIntValue(result) ?? 0;
  }
}
