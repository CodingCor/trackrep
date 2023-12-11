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
  Map<int, List<String>> tableData = {};
  DateTime selectedDate = DateTime.now();

  @override
  void initState(){
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Exercise Log"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.download), 
            onPressed: ()async{
              await saveData();
              if(mounted){
                await showDialog(
                  context: context,
                  builder: (BuildContext context) => const AlertDialog(
                   content: Text('Saved'), 
                  )
                );
              }
            }
          ), 
        ],
      ),
      body: body(),
    );
  }

  Widget body(){
    List<Widget> entries = presentData();
    return Column(
      children: <Widget>[
        dateLine(),
        const Divider(),
        Expanded(
          child: ListView(
            children: entries,
          )
        ),
      ],
    );
  }

  Widget dateLine(){

    return Row(
      children: <Widget>[
        Text("Date ${ExerciseLog.toDateString(selectedDate)}", style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: ()async{
            selectedDate = await showDatePicker(
              context: context,
              firstDate: DateTime.fromMillisecondsSinceEpoch(0),
              initialDate: DateTime.now(),
              lastDate: DateTime.now(),
            ) ?? DateTime.now();
            if(mounted){
              loadData();
              setState((){});
            }
          }
        ),
      ],
    );
  }

  void loadData()async{
    exercises = await DatabaseConnector.getExercises(); 
    log = await DatabaseConnector.getExerciseLogForDate(selectedDate);
    List<MapEntry<int, int>> uniqueCounts = await DatabaseConnector.getUniqueExercisesForDate(selectedDate);
    tableData.clear();

    for(MapEntry<int, int> entry in uniqueCounts){
      List<String> repetitionsForExercise = log.where((ExerciseLog log){return log.exercise == entry.key;}).map((ExerciseLog log){return log.value.toString();}).toList();
      tableData[entry.key] = repetitionsForExercise;
    }

    if(mounted){
      setState((){});
    }
  }

  Future<void> saveData()async{
    
    MediaStore store = MediaStore();
    MediaStore.appFolder = 'trackrep';

    Directory temp = await getTemporaryDirectory();

    // exercise  list to download folder
    File exerciseFile = File('${temp.path}/exercises.txt');
    await exerciseFile.writeAsString('ID; Name; Type\n');
    for(Exercise exercise in exercises){
      await exerciseFile.writeAsString('${exercise.id};${exercise.name};${exercise.type}\n', mode: FileMode.append);
    }
    await exerciseFile.create();
    await store.saveFile(dirType: DirType.download, dirName: DirName.download, tempFilePath: exerciseFile.path, relativePath: FilePath.root);

    // exercise log to file
    File exerciseLogFile = File('${temp.path}/exercise_log.txt');
    await exerciseLogFile.writeAsString('TIMESTAMP;DATE;TIME;Exercise;value\n');
    List<ExerciseLog> log = await DatabaseConnector.getExerciseLog();
    for(ExerciseLog entry in log){

      String line = '';
      line += '${entry.timestamp.millisecondsSinceEpoch.toString()};';
      line += '${ExerciseLog.toDateString(entry.timestamp)};';
      line += '${ExerciseLog.toTimeString(entry.timestamp)};';
      line += '${entry.exercise.toString()};';
      line += '${entry.value.toString()}\n';

      await exerciseLogFile.writeAsString(line, mode: FileMode.append);
    }
    await exerciseLogFile.create();
    await store.saveFile(dirType: DirType.download, dirName: DirName.download, tempFilePath: exerciseLogFile.path, relativePath: FilePath.root);

  }

  List<Widget> presentData(){
    List<Widget> listEntries = [];
    for(MapEntry<int, List<String>> entry in tableData.entries){
      List<Widget>  printColumn = [];
      for(String data in entry.value){
        printColumn.add(
          Text(data, style: Theme.of(context).textTheme.bodyLarge),
        );
      }

      listEntries.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(getExerciseName(entry.key), style: Theme.of(context).textTheme.bodySmall), 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: printColumn,
            ),
            const Divider(),
          ]
        ),
      );      
    }
    return listEntries;
  }

  String getExerciseName(int exerciseId){
    List<Exercise> exerciseListWhereIdMatches = exercises.where((Exercise exercise){return (exercise.id == exerciseId);}).toList();
    if(exerciseListWhereIdMatches.isNotEmpty){
      return exerciseListWhereIdMatches[0].name;
    }
    return "";
  }
}
