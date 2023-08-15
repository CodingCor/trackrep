import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnector{
//TODO: initialize database here
//      calls are to be made in their own service classes
//      each model should get it's own model class to minimize file size
//
//TODO: try creating a DB holding the created Model classes
  static late Database database;

  static Future<void> init() async {
    await reset(); // TODO: remove this in production system database should stay the same
    database = await openDatabase(
      join(await getDatabasesPath(), 'trackrep.db'),
      onCreate: (Database db, int version) {
        return db.execute(dbsql);
      },
      version: 1
    );
  }

  static Future<void> insertExercise(String name) async {
    await database.insert(
      'exercise',
      {
        'name' : name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> reset()async{
    await deleteDatabase(join(await getDatabasesPath(), 'trackrep.db'));
  }

  static Future<String> getExercise(int id) async {
    List<Map<String, dynamic>> list = await database.query(
      'exercise',
      where: "id = ?",
      whereArgs: [id],
    );
    if(list.isEmpty) return "";
    return list[0]['name'];
  }

  static String dbsql = '''
  create table exercise (
      id INTEGER primary key ASC,
      name varchar(60)
  );
  ''';
}
