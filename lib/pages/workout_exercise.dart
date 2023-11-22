import 'package:flutter/material.dart';
import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/services/database.dart';


//TODO: argument from parent page containing the workout 

class WorkoutExercisesPage extends StatefulWidget{
  const WorkoutExercisesPage({super.key});

  @override
  State<StatefulWidget> createState() => _WorkoutExercisesPageState();
}

class _WorkoutExercisesPageState extends State<WorkoutExercisesPage>{


  List<Exercise> exercises = [];

  @override
  void initState(){
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Workout List"),
      ),
      body: exerciseListView(),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: addButtonAction,
      ),
    );
  }

  Widget exerciseListView(){
    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (BuildContext context, int index){
        return ListTile(
          title: Text(exercises[index].name) 
        );
      }
    );
  }

  void addButtonAction(){
    //showDialog(context: context, builder: (BuildContext context){
    //  return AlertDialog(
    //    content: Column(
    //      mainAxisSize: MainAxisSize.min,
    //      children: <Widget>[
    //        TextField(onChanged: (String value){text = value;}),
    //        TextButton(onPressed: saveWorkout, child: const Text("Save")),
    //      ],
    //    ),
    //  );
    //});
  }


  void loadData() async {
    setState((){});
  }
}
