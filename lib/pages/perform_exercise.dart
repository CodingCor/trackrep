import 'package:flutter/material.dart';
import 'package:trackrep/widgets/number_picker.dart';
import 'package:trackrep/widgets/timer.dart';
import 'package:trackrep/models/exercise.dart';

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
      body: (exercise.type == Exercise.timedEventType) ? NumberPicker(text: exercise.name, onChoosen: (){ Navigator.pop(context);}) : Timer( onFinish: (){ Navigator.pop(context);},),
    );
  }
}
