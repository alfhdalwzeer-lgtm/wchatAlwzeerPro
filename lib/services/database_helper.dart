import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/message_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chat_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT NOT NULL,
        isMe INTEGER NOT NULL,
        time TEXT NOT NULL,
        isRead INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertMessage(MessageModel message) async {
    final db = await instance.database;
    return await db.insert('messages', {
      'text': message.text,
      'isMe': message.isMe ? 1 : 0,
      'time': message.time,
      'isRead': message.isRead ? 1 : 0,
    });
  }

  Future<List<MessageModel>> getAllMessages() async {
    final db = await instance.database;
    final result = await db.query('messages');

    return result.map((json) {
      return MessageModel(
        text: json['text'] as String,
        isMe: (json['isMe'] as int) == 1,
        time: json['time'] as String,
        isRead: (json['isRead'] as int) == 1,
      );
    }).toList();
  }

  Future<int> clearAllMessages() async {
    final db = await instance.database;
    return await db.delete('messages');
  }
}
