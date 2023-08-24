import 'package:flutter/material.dart';
import 'package:trackrep/widgets/timer.dart';
import 'package:trackrep/services/database.dart';

import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/models/exercise_log.dart';

import 'dart:io';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.dataset), onPressed: (){
            Navigator.pushNamed(context, "/test");
          }),
        ]
      ),
      body: Timer(finishTime: const Duration(minutes: 1), onFinish: (){print("Finished");}, skipable: true, onSkip: (){print("Skip");}),
    );
  }

  void loadData()async{
    await DatabaseConnector.removeDatabase();
    await DatabaseConnector.insertExercise(Exercise(name: 'Push Up'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Wall Hand Stand Push Up'));
    await DatabaseConnector.insertExercise(Exercise(name: 'V - Raise'));

    List<Exercise> exercises = await DatabaseConnector.getExercises();
    exercises.forEach((Exercise exercise){
      debugPrint('${exercise.id.toString()}\t${exercise.name}');
    });

    // TODO: inserting time does not work
    await DatabaseConnector.insertExerciseLog(ExerciseLog(exercise: 16, value: 12, timestamp: DateTime.now()));
    sleep(const Duration(seconds: 1)); 
    await DatabaseConnector.insertExerciseLog(ExerciseLog(exercise: 16, value: 12, timestamp: DateTime.now()));
    sleep(const Duration(seconds: 1)); 
    await DatabaseConnector.insertExerciseLog(ExerciseLog(exercise: 16, value: 12, timestamp: DateTime.now()));
    sleep(const Duration(seconds: 1)); 
    await DatabaseConnector.insertExerciseLog(ExerciseLog(exercise: 16, value: 12, timestamp: DateTime.now()));
    sleep(const Duration(seconds: 1)); 

    List<ExerciseLog> logs = await DatabaseConnector.getExerciseLog();
    logs.forEach((ExerciseLog logs){
      debugPrint('${logs.exercise.toString()}\t${logs.value.toString()}\t${logs.timestamp.toString()}');
    });
    
  }
}
