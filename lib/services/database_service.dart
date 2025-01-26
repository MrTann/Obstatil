import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/health_info.dart';
import '../models/complaint.dart';
import 'package:logger/logger.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  final _logger = Logger();

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('obstatil.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      // Ana uygulama dizinini al
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String dbPath = join(appDocDir.path, filePath);
      
      // Veritabanı dizininin var olduğundan emin ol
      await Directory(dirname(dbPath)).create(recursive: true);

      _logger.d('Database path: $dbPath'); 

      return await openDatabase(
        dbPath,
        version: 1,
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
        onOpen: (db) async {
          // Veritabanı açıldığında tabloların varlığını kontrol et
          await _ensureTablesExist(db);
        },
      );
    } catch (e) {
      _logger.e('Database initialization error: $e');
      rethrow;
    }
  }

  Future<void> _ensureTablesExist(Database db) async {
    try {
      // Tabloların varlığını kontrol et
      final tables = await db.query(
        'sqlite_master',
        where: 'type = ? AND (name = ? OR name = ?)',
        whereArgs: ['table', 'health_info', 'complaints'],
      );

      // Eğer tablolar yoksa oluştur
      if (tables.isEmpty) {
        await _createDB(db, 1);
      }
    } catch (e) {
      _logger.e('Table check error: $e');
      rethrow;
    }
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Gelecekteki veritabanı güncellemeleri için
    }
  }

  Future<void> _createDB(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS health_info (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          disabilityType TEXT NOT NULL,
          description TEXT NOT NULL,
          additionalNotes TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS complaints (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          imagePath TEXT NOT NULL,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          address TEXT NOT NULL,
          timestamp TEXT NOT NULL,
          description TEXT,
          status TEXT NOT NULL
        )
      ''');
    } catch (e) {
      _logger.e('Database creation error: $e');
      rethrow;
    }
  }

  // Health Info Operations
  Future<HealthInfo> saveHealthInfo(HealthInfo healthInfo) async {
    try {
      final db = await database;
      
      // Önce mevcut kayıtları temizle (sadece bir kayıt tutuyoruz)
      await db.delete('health_info');
      
      final id = await db.insert(
        'health_info',
        healthInfo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // You can use 'id' here or remove it if not needed.
      _logger.d('Health info saved with id: $id'); 

      return HealthInfo(
        id: id,
        disabilityType: healthInfo.disabilityType,
        description: healthInfo.description,
        additionalNotes: healthInfo.additionalNotes,
      );
    } catch (e) {
      _logger.e('Save health info error: $e');
      rethrow;
    }
  }

  Future<HealthInfo?> getHealthInfo() async {
    try {
      final db = await database;
      final maps = await db.query('health_info', limit: 1);
      
      _logger.d('Retrieved health info: $maps'); 

      if (maps.isNotEmpty) {
        return HealthInfo.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      _logger.e('Get health info error: $e');
      rethrow;
    }
  }

  Future<int> updateHealthInfo(HealthInfo healthInfo) async {
    try {
      final db = await database;
      return db.update(
        'health_info',
        healthInfo.toMap(),
        where: 'id = ?',
        whereArgs: [healthInfo.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      _logger.e('Update health info error: $e');
      rethrow;
    }
  }

  // Complaint Operations
  Future<Complaint> saveComplaint(Complaint complaint) async {
    try {
      final db = await database;
      final id = await db.insert('complaints', complaint.toMap());
      // You can use 'id' here or remove it if not needed.
      return complaint;
    } catch (e) {
      _logger.e('Save complaint error: $e');
      rethrow;
    }
  }

  Future<List<Complaint>> getAllComplaints() async {
    try {
      final db = await database;
      final result = await db.query('complaints', orderBy: 'timestamp DESC');
      return result.map((map) => Complaint.fromMap(map)).toList();
    } catch (e) {
      _logger.e('Get all complaints error: $e');
      rethrow;
    }
  }

  Future<int> updateComplaint(Complaint complaint) async {
    try {
      final db = await database;
      return db.update(
        'complaints',
        complaint.toMap(),
        where: 'id = ?',
        whereArgs: [complaint.id],
      );
    } catch (e) {
      _logger.e('Update complaint error: $e');
      rethrow;
    }
  }

  Future<void> deleteComplaint(int id) async {
    try {
      final db = await database;
      await db.delete(
        'complaints',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      _logger.e('Delete complaint error: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
} 