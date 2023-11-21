import 'package:flutter/material.dart';
import 'package:trackrep/models/workout.dart';
import 'package:trackrep/services/database.dart';

class WorkoutListPage extends StatefulWidget{
  const WorkoutListPage({super.key});

  @override
  State<StatefulWidget> createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage>{

  String text = '';
  bool timedEvent = false;

  List<Workout> workoutList = [];

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
      body: workoutListView(),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: addButtonAction,
      ),
    );
  }

  Widget workoutListView(){
    return ListView.builder(
      itemCount: workoutList.length,
      itemBuilder: (BuildContext context, int index){
        return ListTile(
          title: Text(workoutList[index].name) 
        );
      }
    );
  }

  void addButtonAction(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(onChanged: (String value){text = value;}),
            TextButton(onPressed: saveWorkout, child: const Text("Save")),
          ],
        ),
      );
    });
  }


  void saveWorkout()async{
    //await DatabaseConnector.insertExercise(Exercise(name: text, type: (timedEvent) ? Exercise.timedEventType : Exercise.defaultType));
    if(mounted){
      Navigator.pop(context);
      setState((){});
    }
  }

  void loadData() async {
    workoutList = await DatabaseConnector.getWorkouts(); 
    setState((){});
  }
}
