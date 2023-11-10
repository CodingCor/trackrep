import 'package:flutter/material.dart';
import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/services/database.dart';

class ExerciseListController{
  bool loaded = false;
}
class ExerciseList extends StatefulWidget {
  final void Function(Exercise exercise) onTap;
  final ExerciseListController controller; 
  const ExerciseList({super.key, required this.onTap, required this.controller});

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList>{
  
  List<Exercise> exercises = [];

  String text = '';
  bool timedEvent = false;

  @override
  Widget build(BuildContext context){
    if(!widget.controller.loaded){
      loadData();
    }
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
    debugPrint('loaded');
    if(mounted){
      widget.controller.loaded = true;
      setState((){});
    }
  }
}
