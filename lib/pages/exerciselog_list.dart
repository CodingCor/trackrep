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
  DateTime selectedDate = DateTime.now();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    loadData();
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
