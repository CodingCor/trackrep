import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/models/exercise_log.dart';
//TODO: somehow insert is not working anymore
//
import 'dart:convert';

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

  static Future<void> insertExercise(Exercise exercise) async {
    print(jsonEncode(Exercise.toMap(exercise)));
    await database.insert(
      'exercise',
      Exercise.toMap(exercise),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> reset()async{
    await deleteDatabase(join(await getDatabasesPath(), 'trackrep.db'));
  }

  static Future<Exercise?> getExercise(int id) async {
    List<Map<String, dynamic>> list = await database.query(
      'exercise',
      where: "id = ?",
      whereArgs: [id],
    );
    if(list.isEmpty) return null;
    return Exercise.fromMap(list[0]);
  }

  static Future<List<Map<String, dynamic>>> getExercises() async {
    List<Map<String, dynamic>> list = await database.query(
      'exercise'
    );
    return list;
  }

  static String dbsql = '''
  create table exercise (
    id INTEGER primary key ASC,
    name varchar(60) unique 
  );

  create table exercise_log(
    logdate date,
    logtime time,
    exercise INTEGER,
    value int,
    primary(logdate, logtime, exercise)
  );
  ''';
}
