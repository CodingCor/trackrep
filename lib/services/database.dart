import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/models/exercise_log.dart';
import 'dart:convert';

class DatabaseConnector{

  static Future<Database> getInstance() async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'trackrep.db'),
      onCreate: (Database db, int version) async {
        for(String table in databaseTables){
          await db.execute(table);
        }
      },
      version: 1,
      singleInstance: true,
    );
    return database;
  }

  static Future<void> removeDatabase() async{
    await deleteDatabase(
      join(await getDatabasesPath(), 'trackrep.db'),
    );
  }

  ///
  ///   Model Exercise Calls
  ///

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

  static Future<void> printTables()async {
    Database database = await getInstance();
    List<Map<String, dynamic>> query = await database.rawQuery('select * from sqlite_master;');
    for(Map<String, dynamic> entry in query){
      print(jsonEncode(entry));
    }
  }

  ///
  ///   Model ExerciseLog Calls
  ///
  static Future<void> insertExerciseLog(ExerciseLog log) async{
    Database database = await getInstance();
    await database.insert(
      'exerciselog',
      ExerciseLog.toMap(log),
      conflictAlgorithm: ConflictAlgorithm.ignore
    );
  }

  static Future<List<ExerciseLog>> getExerciseLog() async{
    Database database = await getInstance();
    List<Map<String, dynamic>> query = await database.query(
      'exerciselog',
    );
    List<ExerciseLog> logs = query.map((Map<String, dynamic> entry){return ExerciseLog.fromMap(entry);}).toList();
    return logs;
  }

  static List<String> databaseTables = [
    '''
    create table exercise (
      id INTEGER primary key ASC,
      type varchar(1),
      name varchar(60) unique
    );
    ''' 
  ,
    '''
    create table exerciselog(
      logdate varchar(10),
      logtime varcahr(5),
      exercise INTEGER,
      value int,
      primary key (logdate, logtime, exercise)
    );
    '''
  ];
}
