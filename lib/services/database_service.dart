import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static Database? _database;
  static final DatabaseService instance = DatabaseService._internal();
  
  factory DatabaseService() {
    return instance;
  }
  
  DatabaseService._internal();
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'sentinel_guard.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE parent_info (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        pin TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE screen_time (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        duration_seconds INTEGER NOT NULL,
        started_at TEXT,
        ended_at TEXT
      )
    ''');
  }
  
  // Parent Info Methods
  Future<void> saveParentInfo(String name, String pin) async {
    final db = await database;
    
    // Delete existing
    await db.delete('parent_info');
    
    // Insert new
    await db.insert('parent_info', {
      'name': name,
      'pin': pin,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
  
  Future<Map<String, String>?> getParentInfo() async {
    final db = await database;
    final result = await db.query('parent_info', limit: 1);
    
    if (result.isEmpty) return null;
    
    return {
      'name': result.first['name'] as String,
      'pin': result.first['pin'] as String,
    };
  }
  
  Future<bool> verifyPin(String pin) async {
    final info = await getParentInfo();
    if (info == null) return pin == '123456'; // Fallback
    return info['pin'] == pin;
  }
  
  // Screen Time Methods
  Future<void> startScreenTime() async {
    final db = await database;
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    await db.insert('screen_time', {
      'date': today,
      'duration_seconds': 0,
      'started_at': DateTime.now().toIso8601String(),
      'ended_at': null,
    });
  }
  
  Future<void> updateScreenTime(int durationSeconds) async {
    final db = await database;
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    final existing = await db.query(
      'screen_time',
      where: 'date = ? AND ended_at IS NULL',
      whereArgs: [today],
    );
    
    if (existing.isNotEmpty) {
      await db.update(
        'screen_time',
        {
          'duration_seconds': durationSeconds,
          'ended_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    }
  }
  
  Future<int> getTodayScreenTime() async {
    final db = await database;
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    final result = await db.rawQuery('''
      SELECT SUM(duration_seconds) as total
      FROM screen_time
      WHERE date = ?
    ''', [today]);
    
    if (result.isEmpty || result.first['total'] == null) {
      return 0;
    }
    
    return result.first['total'] as int;
  }
}
