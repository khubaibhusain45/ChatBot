import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ChatDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'chatbot.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE chats (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            role TEXT,
            message TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertChat(String role, String message) async {
    final db = await database;
    await db.insert('chats', {'role': role, 'message': message});
  }

  static Future<List<Map<String, dynamic>>> fetchChats() async {
    final db = await database;
    return await db.query('chats', orderBy: 'id ASC');
  }

  static Future<void> clearChats() async {
    final db = await database;
    await db.delete('chats');
  }
}
