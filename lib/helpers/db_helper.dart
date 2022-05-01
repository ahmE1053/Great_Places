import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> dbGetter() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT,description TEXT,address TEXT,favorite INTEGER)');
    }, version: 1);
  }

  static Future<void> insert(Map<String, dynamic> data) async {
    final db = await DBHelper.dbGetter();
    await db.insert('user_places', data);
  }

  static Future<void> changeFavorite(int state, String id) async {
    final db = await DBHelper.dbGetter();
    try {
      // await db.update('user_places', data, where: 'id=?', whereArgs: [id]);
      await db.rawUpdate('''
      UPDATE user_places
      SET favorite=?
      WHERE id=?
      ''', [state, id]);
    } catch (error) {
      print('Update error $error');
    }
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await DBHelper.dbGetter();
    return await db.query('user_places');
  }
}
