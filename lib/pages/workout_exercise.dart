import 'package:flutter/material.dart';
import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/models/workout.dart';
import 'package:trackrep/services/database.dart';
import 'package:trackrep/widgets/exercise_list.dart';


//TODO: argument from parent page containing the workout 

class WorkoutExercisesPage extends StatefulWidget{
  const WorkoutExercisesPage({super.key});

  @override
  State<StatefulWidget> createState() => _WorkoutExercisesPageState();
}

class _WorkoutExercisesPageState extends State<WorkoutExercisesPage>{


  List<Exercise> exercises = [];
  Workout workout = Workout(name: '');
  bool loaded = false;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    Object? obj = ModalRoute.of(context)!.settings.arguments;
    if(obj != null && obj is Workout){
      workout = obj;
    }
    if(loaded){
      DatabaseConnector.fillWorkout(workout, exercises);
    }
    loadData();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Exercise List for Workout ${workout.name}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer_outlined),
            onPressed: (){}
          ),
        ]
      ),
      body: exerciseListView(),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: addButtonAction,
      ),
    );
  }

  Widget exerciseListView(){
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex){
        if(oldIndex < newIndex){
          newIndex -= 1;
        }
        Exercise exercise = exercises.elementAt(oldIndex);
        exercises.removeAt(oldIndex);
        exercises.insert(newIndex, exercise);
        setState((){});
      },
      children: exercises.map((Exercise exercise){
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (DismissDirection direction){
            exercises.remove(exercise);
            setState((){});
          },
          child: ListTile(
            title: Text(exercise.name),
            onTap: (){
              Navigator.pushNamed(context, '/exercise/perform', arguments: exercise);
            }
          ),
        );
      }).toList(), 
    );
  }

  void addButtonAction(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(content: ExerciseList(
        onTap: (Exercise exercise){
          exercises.add(exercise);
          Navigator.pop(context);
          setState((){});
        },
        controller: ExerciseListController()
      ));
    });
  }


  void loadData() async {
    if(loaded) return;
    exercises = await DatabaseConnector.getExercisesForWorkout(workout);
    if(mounted){
      setState((){});
    }
    loaded = true;
  }
}
