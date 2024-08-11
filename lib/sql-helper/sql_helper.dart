import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart' as sql;
import 'package:sql_notes/model/notes_model.dart';

class SQLHelper {
  const SQLHelper();

  static Future<void> createDatabase(sql.Database database) async {
    await database.execute("""
    CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
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

  /// to create new note into database
  static Future<int> createNewNote(Notes notes) async {
    final db = await SQLHelper.db();
    final id = await db.insert('items', notes.toMap());
    return id;
  }

  /// get list of Notes from database
  static Future<List<Notes>> getListOfNotes() async {
    final db = await SQLHelper.db();
    final listOfNotes = await db.query('items');
    return listOfNotes.map((e) => Notes.fromMap(e)).toList();
  }

  /// get note by ID from database
  static Future<Notes> getNoteById(int id) async {
    final db = await SQLHelper.db();
    final note = await db.query(
      'items',
      where: 'noteId=?',
      limit: 1,
    );
    return Notes.fromMap(note.first);
    // if (note != null) {
    //   return Notes.fromMap(note.first);
    // } else {
    //   throw Exception('Id not found');
    // }
  }

  /// update Note into database
  static Future<int> updateNote(Notes note) async {
    final db = await SQLHelper.db();
    final result = await db.update('items', note.toMap(),
        where: 'noteId=?', whereArgs: [note.noteId]);
    return result;
  }

  /// Delete Note
  static Future deleteNote(int id) async {
    final db = await SQLHelper.db();
    db.delete('items', where: 'noteId=?', whereArgs: [id]);
  }
}
