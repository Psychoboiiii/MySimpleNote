import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'note.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Use the ffi web factory on the web platform
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    String path; // initiate database path var
    if (kIsWeb) {
      // Web-specific database path (for web platforms, this is the db path)
      path = 'notes_db.db';
    } else {
      // Mobile/desktop path (for mobile/desktop platforms, this is the db path)
      path = await getDatabasesPath();
      path = join(path, 'notes_db.db');
    }

    // Open the database using the web-specific factory
    return await databaseFactoryFfiWeb.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        date TEXT
      )
    ''');
  }

  Future<int> insertNote(Note note) async {
    Database db = await database;
    print("Inserting note: ${note.toMap()}");
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> updateNote(Note note) async {
    Database db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNoteById(int id) async {
    Database db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
