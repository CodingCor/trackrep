import 'package:flutter/material.dart';
import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/models/exercise_log.dart';
import 'package:trackrep/services/database.dart';

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
