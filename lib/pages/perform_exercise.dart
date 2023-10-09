import 'package:flutter/material.dart';
import 'package:trackrep/widgets/number_picker.dart';
import 'package:trackrep/widgets/timer.dart';
import 'package:trackrep/models/exercise.dart';

import 'package:trackrep/services/database.dart';
import 'package:trackrep/models/exercise_log.dart';

class PerformExercise extends StatefulWidget{
  const PerformExercise({super.key}); 

  @override
  State<PerformExercise> createState() => _PerformExerciseState();
}

class _PerformExerciseState extends State<PerformExercise>{

  late Exercise exercise;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    exercise = ModalRoute.of(context)!.settings.arguments as Exercise;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Perform Exercise"),
      ),
      body: (exercise.type == Exercise.defaultType) ? 
        NumberPicker(
          text: exercise.name, 
          onChoosen: (int value){
            logExercise(exercise, value);
            Navigator.pop(context);
          }
        ) 
        : 
        Timer(
          text: exercise.name, 
          onFinish: (int seconds){ 
            logExercise(exercise, seconds);
            Navigator.pop(context);
          },
        ),
    );
  }

  void logExercise(Exercise exercise, int value)async{
    if(exercise.id != null){
      await DatabaseConnector.insertExerciseLog(ExerciseLog(timestamp: DateTime.now(), value: value, exercise: exercise.id!));
    }
  }
}
