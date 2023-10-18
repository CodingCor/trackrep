import 'package:flutter/material.dart';
import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/models/exercise_log.dart';
import 'package:trackrep/services/database.dart';

import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ExerciseLogList extends StatefulWidget{
  const ExerciseLogList({super.key});

  @override
  State<StatefulWidget> createState() => _ExerciseLogListState();
}

class _ExerciseLogListState extends State<ExerciseLogList>{

  List<Exercise> exercises = [];
  List<ExerciseLog> log = [];

  @override
  void initState(){
    super.initState();
    loadData();
  }
  @override
  Widget build(BuildContext context){
    List<Widget> entries = presentData();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Exercise Log"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete), 
            onPressed: ()async{
              await DatabaseConnector.reset(); 
              if(mounted){
                setState((){});
              }
            }
          ), 
          IconButton(
            icon: const Icon(Icons.download), 
            onPressed: (){

            }
          ), 
        ],
      ),
      body: ListView(
        children: entries,
      ),
    );
  }

  void loadData()async{
    exercises = await DatabaseConnector.getExercises(); 
    log = await DatabaseConnector.getExerciseLog();
    if(mounted){
      setState((){});
    }
  }

  void saveData()async{
    
    MediaStore store = MediaStore();
    MediaStore.appFolder = 'trackrep';

    Directory temp = await getTemporaryDirectory();
    //
    // exercise  list to download folder
    File exerciseFile = File('${temp.path}/exercises.csv');
    await exerciseFile.writeAsString('ID; Name; Type\n');
    for(Exercise exercise in exercises){
      await exerciseFile.writeAsString('${exercise.id};${exercise.name};${exercise.type}\n');
    }
    exerciseFile.create();
    await store.saveFile(dirType: DirType.download, dirName: DirName.download, tempFilePath: exerciseFile.path, relativePath: FilePath.root);

    File exerciseLogFile = File('${temp.path}/exercise_log.csv');
    await exerciseLogFile.writeAsString('TIMESTAMP;DATE;TIME;Exercise;value\n');
    for(ExerciseLog entry in log){

      await exerciseLogFile.writeAsString('''
        ${entry.timestamp.millisecondsSinceEpoch};
        ${ExerciseLog.toDateString(entry.timestamp)};
        ${ExerciseLog.toTimeString(entry.timestamp)};
        ${entry.exercise.toString()};
        ${entry.value.toString()}
      ''');
    }
    exerciseLogFile.create();
    await store.saveFile(dirType: DirType.download, dirName: DirName.download, tempFilePath: exerciseLogFile.path, relativePath: FilePath.root);

  }

  List<Widget> presentData(){
      List<Widget> listEntries = [];
      String? dateStamp;
      for(ExerciseLog entry in log){
        // title line
        if(dateStamp != ExerciseLog.toDateString(entry.timestamp)){
          dateStamp = ExerciseLog.toDateString(entry.timestamp);
          listEntries.add(ListTile(
            title: Text(ExerciseLog.toDateString(entry.timestamp), style: const TextStyle(fontWeight: FontWeight.bold))
          )); 
        }

        //exercise name
        List<Exercise> exerciseListWhereIdMatches = exercises.where((Exercise exercise){return (exercise.id == entry.exercise);}).toList();
        String exerciseName = '';
        if(exerciseListWhereIdMatches.isNotEmpty){
          exerciseName = exerciseListWhereIdMatches[0].name;
        }

        // log line
        listEntries.add(ListTile(
          title: Text(exerciseName),
          trailing: Text(entry.value.toString()),
        ));

      }
      return listEntries;
  }
}
