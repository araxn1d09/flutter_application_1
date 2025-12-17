import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/bmi_record.dart';

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
    String path = join(await getDatabasesPath(), 'bmi_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bmi_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        gender TEXT NOT NULL,
        weight REAL NOT NULL,
        height REAL NOT NULL,
        bmi REAL NOT NULL,
        category TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // Добавить запись
  Future<int> insertRecord(BMIRecord record) async {
    Database db = await database;
    return await db.insert('bmi_records', record.toMap());
  }

  // Получить все записи
  Future<List<BMIRecord>> getAllRecords() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bmi_records',
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) {
      return BMIRecord.fromMap(maps[i]);
    });
  }

  // Удалить запись
  Future<void> deleteRecord(int id) async {
    Database db = await database;
    await db.delete(
      'bmi_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Удалить все записи
  Future<void> deleteAllRecords() async {
    Database db = await database;
    await db.delete('bmi_records');
  }

  // Получить количество записей
  Future<int> getRecordsCount() async {
    Database db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM bmi_records')
    );
    return count ?? 0;
  }
}