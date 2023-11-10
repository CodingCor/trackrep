import 'package:flutter/material.dart';
import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/services/database.dart';

import 'package:trackrep/widgets/exercise_list.dart';

class ExerciseListPage extends StatefulWidget{
  const ExerciseListPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage>{

  ExerciseListController controller = ExerciseListController();
  String text = '';
  bool timedEvent = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Exercise List"),
      ),
      body: ExerciseList(
        onTap: (Exercise exercise){
          Navigator.pushNamed(context, '/exercise/perform', arguments: exercise);
        },
        controller: controller,
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


  void saveExercise()async{
    await DatabaseConnector.insertExercise(Exercise(name: text, type: (timedEvent) ? Exercise.timedEventType : Exercise.defaultType));
    if(mounted){
      Navigator.pop(context);
      controller.loaded = false;
      setState((){});
    }
  }
}
