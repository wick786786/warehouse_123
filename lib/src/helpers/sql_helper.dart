import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

// Add these imports
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqlHelper {
  // Call this function at the start of your application
  static void initializeDatabaseFactory() {
    if (!kIsWeb) {
      sqfliteFfiInit();
      sql.databaseFactory = databaseFactoryFfi;
    }
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute(
      """CREATE TABLE info(
           id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
           manufacturer TEXT,
           model TEXT,
           iemi TEXT,
           sno TEXT,
           createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""",
    );
//     await database.execute("""
//       CREATE TABLE test_details(
//       speaker TEXT,
//       vibration TEXT, 
//       front_Camera TEXT,
//       back_camera TEXT,



//       )

// """);
  }

  static Future<sql.Database> db() async {
  return sql.openDatabase(
    'detail.db',
    version: 1, // Increment the version number
    onCreate: (sql.Database database, int version) async {
      await createTables(database);
    },
    onUpgrade: (sql.Database database, int oldVersion, int newVersion) async {
      if (oldVersion < 2) {
        // Add the manufacturer column if upgrading from a version lower than 2
        await database.execute('ALTER TABLE info ADD COLUMN manufacturer TEXT');
      }
    },
  );
}


  static Future<int> createItem(String? manufacturer,String? model, String? iemi, String? sno) async {
    final db = await SqlHelper.db();
    final data = {'manufacturer':manufacturer,'model': model, 'iemi': iemi, 'sno': sno};
    final id = await db.insert('info', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SqlHelper.db();
    return db.query('info', orderBy: "id");
  }
}
