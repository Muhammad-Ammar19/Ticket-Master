import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'tickets.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tickets(id INTEGER PRIMARY KEY AUTOINCREMENT, seatNumber TEXT, section TEXT, row TEXT, date TEXT, time TEXT, imageUrl TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertTicket(Map<String, dynamic> ticket) async {
    final db = await database;
    await db.insert('tickets', ticket, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getTickets() async {
    final db = await database;
    return db.query('tickets');
  }

  Future<void> updateTicket(int id, Map<String, dynamic> ticket) async {
    final db = await database;
    await db.update(
      'tickets',
      ticket,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTicket(int id) async {
    final db = await database;
    await db.delete(
      'tickets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
