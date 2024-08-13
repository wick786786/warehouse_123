import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqlHelper {
  // Call this function at the start of your application to initialize the database factory
  static void initializeDatabaseFactory() {
    if (!kIsWeb) {
      sqfliteFfiInit();
      sql.databaseFactory = databaseFactoryFfi;
    }
  }

  // Function to create tables
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
      """
      CREATE TABLE info(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        manufacturer TEXT,
        model TEXT,
        iemi TEXT,
        sno TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """,
    );
    await database.execute(
      """
      CREATE TABLE device_summary(
        deviceId TEXT PRIMARY KEY,
        wifi TEXT
      )
      """,
    );
  }

  // Function to open or create a new database
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'new_database.db', // New database name
      version: 1, // Increment the version number if you make changes to the schema
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Function to insert a new item into the 'info' table
  static Future<int> createItem(String? manufacturer, String? model, String? iemi, String? sno) async {
    final db = await SqlHelper.db();
    final data = {
      'manufacturer': manufacturer,
      'model': model,
      'iemi': iemi,
      'sno': sno,
    };
    final id = await db.insert('info', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Function to retrieve all items from the 'info' table
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SqlHelper.db();
    return db.query('info', orderBy: "id");
  }

  // Function to delete an item from the 'info' table by its ID
  static Future<int> deleteItem(int id) async {
    final db = await SqlHelper.db();
    return await db.delete(
      'info',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Function to insert device details into the 'device_summary' table
  static Future<void> createDeviceInfo(String? deviceId, String? wifi) async {
    final db = await SqlHelper.db();
    final data = {
      'deviceId': deviceId ?? 'null',
      'wifi': wifi ?? 'null',
    };
    await db.insert('device_summary', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  // Function to delete the database
  static Future<void> deleteDatabase() async {
    final path = await sql.getDatabasesPath();
    final dbPath = '$path/new_database.db'; // Use the new database name
    await databaseFactoryFfi.deleteDatabase(dbPath);
    print("Database deleted: $dbPath");
  }
}
