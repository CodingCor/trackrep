import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/models/exercise_log.dart';
import 'package:trackrep/models/workout.dart';
import 'dart:convert';

//TODO: need a way to export the whole database to the device for later import 
//  path_provider might help to get the download directory of the device
//  permission_handler might help to get the appropriate permissions for the folder
//  export the db as 2 files
//    one containing the log
//    one containing the names and type of the exercise
//
//    2. idea:
//
//    media_store_plus instead of path_provider and permission_handler as downloads folder is not accessible through path_provider as scoped storage is needed

class DatabaseConnector{

  static Future<Database> getInstance() async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'trackrep.db'),
      onCreate: (Database db, int version) async {
        executeAll(db, databaseTables);
      },
      onUpgrade: (Database db, int versionBefore, int versionAfter) async{
        if(versionAfter > 1) {
          executeAll(db, databaseTablesVersion2);
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

  static Future<void> removeExercise(int exerciseID) async{
    Database database = await getInstance();
    await database.delete(
      'exercise',
      where: "id = ?",
      whereArgs: [exerciseID.toString()]
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

  static Future<List<ExerciseLog>> getExerciseLogForDate(DateTime date) async{
    String dateString = ExerciseLog.toDateString(date);
    Database database = await getInstance();
    List<Map<String, dynamic>> query = await database.query(
      'exerciselog',
      where: 'logdate="$dateString"'
    );
    List<ExerciseLog> logs = query.map((Map<String, dynamic> entry){return ExerciseLog.fromMap(entry);}).toList();
    return logs;
  }

  static Future<List<MapEntry<int, int>>> getUniqueExercisesForDate(DateTime date) async{
    String dateString = ExerciseLog.toDateString(date);
    Database database = await getInstance();
    List<MapEntry<int, int>> uniqueCounts = [];
    List<Map<String, dynamic>> query = await database.rawQuery(
      'select count(*), exercise, logtime from exerciselog where logdate="$dateString" group by exercise order by logtime;'
    );
    for(Map<String, dynamic> entry in query){
      int exercise = entry['exercise'];
      int count = entry['count(*)'];
      uniqueCounts.add(MapEntry<int, int>(exercise, count));
    }
    return uniqueCounts;
  }

  static Future<void> executeAll(Database db, List<String> statements) async{
    for(String table in statements){
      await db.execute(table);
    }
  }

  static List<String> databaseTables = [ Exercise.tableString, ExerciseLog.tableString]; 
  static List<String> databaseTablesVersion2 = [ Workout.tableString]; 
}
