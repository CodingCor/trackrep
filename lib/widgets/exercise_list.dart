import 'package:flutter/material.dart';
import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/services/database.dart';

class ExerciseList extends StatefulWidget {
  final void Function(Exercise exercise) onTap;
  const ExerciseList({super.key, required this.onTap});

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList>{
  
  List<Exercise> exercises = [];


  String text = '';
  bool timedEvent = false;

  @override
  void initState(){
    super.initState();
    loadData(); 
  }
  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (BuildContext context, int id) {
        Exercise exercise = exercises[id];
        return ListTile(
          onTap: (){
            widget.onTap(exercises[id]);
          },
          title: Text(exercise.name),
        );
      }
    );
  }

  void loadData()async{
    exercises = await DatabaseConnector.getExercises(); 
    if(mounted){
      setState((){});
    }
  }
}
