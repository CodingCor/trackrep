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
  List<Exercise> queriedExercises = [];

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context){
    if(!widget.controller.loaded){
      loadData();
    }
    return Column(
      children: <Widget>[
        searchBar(),
        const Divider(),
        Expanded( child: exerciseList()),
      ]
    );
  }

  Widget exerciseList(){
    return ListView.builder(
      itemCount: queriedExercises.length,
      itemBuilder: (BuildContext context, int id) {
        Exercise exercise = queriedExercises[id];
        return ListTile(
          onTap: (){
            widget.onTap(exercise);
          },
          title: Text(exercise.name),
        );
      }
    );
  }

  Widget searchBar(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(child: TextField( controller: controller)),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: (){
            loadData();
          }
        ),
      ]
    );
  }

  void loadData()async{
    exercises = await DatabaseConnector.getExercises(); 

    if(controller.text.isNotEmpty){
      queriedExercises = exercises.where((Exercise exercise){
        return exercise.name.toLowerCase().contains(controller.text.toLowerCase());
      }).toList(); 
    }else{
      queriedExercises = exercises;
    }

    if(mounted){
      widget.controller.loaded = true;
      setState((){});
    }
  }
}
