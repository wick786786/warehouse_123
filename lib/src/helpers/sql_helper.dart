import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        ram TEXT,          -- New column for RAM
        mdm_status TEXT,   -- New column for MDM status
        oem TEXT,          -- New column for OEM lock
        
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """,
    );
  }

  // Function to upgrade the database schema when the version changes
  static Future<void> upgradeDatabase(sql.Database database, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new columns if upgrading from version 1 to 2
      await database.execute("ALTER TABLE info ADD COLUMN ram TEXT;");
      await database.execute("ALTER TABLE info ADD COLUMN mdm_status TEXT;");
      await database.execute("ALTER TABLE info ADD COLUMN oem TEXT;");
    }
  }

  // Function to open or create a new database
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'new_databasev2.db', // New database name
      version: 2, // Incremented version number to trigger schema upgrade
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
      onUpgrade: (sql.Database database, int oldVersion, int newVersion) async {
        await upgradeDatabase(database, oldVersion, newVersion);
      },
    );
  }

  // Function to insert a new item into the 'info' table
  static Future<int> createItem(String? manufacturer, String? model, String? iemi, String? sno, String? ram, String? mdm, String? oem) async {
    final db = await SqlHelper.db();
    
    // Check if a row with the same iemi or sno already exists
    final List<Map<String, dynamic>> existingItem = await db.query(
      'info',
      where: 'iemi = ? OR sno = ?',
      whereArgs: [iemi, sno],
    );

    // If the item exists, update it; otherwise, insert a new row
    if (existingItem.isNotEmpty) {
      final id = existingItem.first['id'];
      final data = {
        'manufacturer': manufacturer,
        'model': model,
        'iemi': iemi,
        'sno': sno,
        'ram': ram,                // Add RAM value
        'mdm_status': mdm,         // Add MDM status value
        'oem': oem,                // Add OEM lock value
      };
      return await db.update(
        'info',
        data,
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } else {
      final data = {
        'manufacturer': manufacturer,
        'model': model,
        'iemi': iemi,
        'sno': sno,
        'ram': ram,                // Add RAM value
        'mdm_status': mdm,         // Add MDM status value
        'oem': oem,                // Add OEM lock value
      };
      return await db.insert('info', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
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

  // Function to get item details by iemi or sno
  static Future<Map<String, dynamic>?> getItemDetails(String? deviceId) async {
    final db = await SqlHelper.db();
    final List<Map<String, dynamic>> result = await db.query(
      'info',
      where: 'sno = ?',
      whereArgs: [deviceId],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  static Future<void> deleteDeviceProgress(String? deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$deviceId-progress';

    if (prefs.containsKey(key)) {
      await prefs.remove(key);
      print('Progress for device "$deviceId" deleted from SharedPreferences.');
    } else {
      print('No progress found for device "$deviceId" in SharedPreferences.');
    }
  }

  static Future<int> deleteItemwithId(String? id) async {
    final db = await SqlHelper.db();

    await deleteDeviceProgress(id);

    return await db.delete(
      'info',
      where: 'sno = ?',
      whereArgs: [id],
    );
  }

  // Function to delete the database
  static Future<void> deleteDatabase() async {
    final path = await sql.getDatabasesPath();
    final dbPath = '$path/new_databasev2.db'; // Use the new database name
    await databaseFactoryFfi.deleteDatabase(dbPath);
    print("Database deleted: $dbPath");
  }
}
