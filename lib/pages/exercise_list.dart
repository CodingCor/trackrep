import 'package:flutter/material.dart';
import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/services/database.dart';

class ExerciseList extends StatefulWidget{
  const ExerciseList({super.key});

  @override
  State<StatefulWidget> createState() => _ExerciseListState();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Exercise List"),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (BuildContext context, int id) {
          Exercise exercise = exercises[id];
          return Dismissible(
            onDismissed: (DismissDirection direction){removeExercise(id);},
            key: UniqueKey(),
            child:  ListTile(
              onTap: (){
                Navigator.pushNamed(context, '/exercise/perform', arguments: exercises[id]);
              },
              title: Text(exercise.name),
            ),
          );
        }
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: (){
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(onChanged: (String value){text = value;}),
                  TextField(
                    onChanged: (String value){
                      if(value == 'T'){
                        timedEvent = true;
                      }else{
                        timedEvent = false;
                      }
                    }
                  ),
                  TextButton(onPressed: saveExercise, child: const Text("Save")),
                ],
              ),
            );
          });
        }
      ),
    );
  }

  void loadData()async{
    exercises = await DatabaseConnector.getExercises(); 
    if(mounted){
      setState((){});
    }
  }

  void removeExercise(int id)async{
    await DatabaseConnector.removeExercise(exercises[id].id!);
    loadData();
  }

  void saveExercise()async{
    await DatabaseConnector.insertExercise(Exercise(name: text, type: (timedEvent) ? Exercise.timedEventType : Exercise.defaultType));
    if(mounted){
      Navigator.pop(context);
      loadData();
    }
  }
}
