import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart' as sql;

class SQLHelper {
  static Future<void> createDatabase(sql.Database database) async {
    await database.execute("""
    CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    creatEAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  static Future<sql.Database> db() async {
    return openDatabase(
      'note.db',
      version: 1,
      onCreate: (database, version) async {
        await createDatabase(database);
      },
    );
  }

  /// to create new data in database
  static Future<int> createNewNote(String title, String? description) async {
    final db = await SQLHelper.db();
    final data = {'title': title, 'description': description};
    final id = await db.insert('items', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  /// query to ask for list of data from database
  static Future<List<Map<String, dynamic>>> getListOfItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: 'id=?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(
      int id, String title, String? description) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'description': description,
      'createAt': DateTime.now().toString()
    };
    final result =
        await db.update('items', data, where: 'id=?', whereArgs: [id]);
    return result;
  }

  static Future deleteItem(int id) async {
    final db = await SQLHelper.db();
    db.delete('items', where: 'id=?', whereArgs: [id]);
  }
}
