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

  static Future<Database> getInstance() async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'trackrep.db'),
      onCreate: (Database db, int version) {
        return db.execute(dbsql);
      },
      version: 1,
      singleInstance: true,
    );
    return database;
  }

  static Future<void> insertExercise(Exercise exercise) async {
    Database database = await getInstance();
    await database.insert(
      'exercise',
      Exercise.toMap(exercise),
      conflictAlgorithm: ConflictAlgorithm.ignore
    );
  }

  static Future<void> reset()async{
    await deleteDatabase(join(await getDatabasesPath(), 'trackrep.db'));
  }

  static Future<Exercise?> getExercise(int id) async {
    Database database = await getInstance();
    List<Map<String, dynamic>> list = await database.query(
      'exercise',
      where: "id = ?",
      whereArgs: [id],
    );
    if(list.isEmpty) return null;
    return Exercise.fromMap(list[0]);
  }

  static Future<List<Exercise>> getExercises() async{
    Database database = await getInstance();
    List<Map<String, dynamic>> list = await database.query(
      'exercise',
    );

    List<Exercise> exercises = list.map((Map<String, dynamic> entry){ return Exercise.fromMap(entry);}).toList();
    return exercises;
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
