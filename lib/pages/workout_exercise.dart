import 'package:flutter/material.dart';
import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/models/workout.dart';
import 'package:trackrep/services/database.dart';
import 'package:trackrep/widgets/exercise_list.dart';
import 'package:trackrep/widgets/timer.dart';


//TODO: argument from parent page containing the workout 

class WorkoutExercisesPage extends StatefulWidget{
  const WorkoutExercisesPage({super.key});

  @override
  State<StatefulWidget> createState() => _WorkoutExercisesPageState();
}

class _WorkoutExercisesPageState extends State<WorkoutExercisesPage>{


  List<Exercise> exercises = [];
  Exercise? lastActiveExercise;
  Workout workout = Workout(name: '');
  bool loaded = false;
  int index = 0;

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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Exercise List for Workout ${workout.name}"),
          actions: [
            IconButton(
              icon: const Icon(Icons.list_outlined),
              onPressed: (){
                Navigator.pushNamed(context, '/exercise_log/list');
              }
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.timer_outlined)),
              Tab(icon: Icon(Icons.fitness_center_outlined)),
            ] 
          ),
        ),
        body: TabBarView(
          children: [
            exerciseListView(),
            const Timer(),
          ]
        ),
        floatingActionButton: IconButton(
          icon: const Icon(Icons.add),
          onPressed: (){
            debugPrint("${DefaultTabController.of(context).index}");
          }//addButtonAction,
        ),
      )
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
          background: Container(
            color: Theme.of(context).colorScheme.error,
            child: Row(
              children: <Widget>[
                const SizedBox(width: 8.0),
                Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.onError),
                const Spacer(),
              ]
            ),
          ),
          onDismissed: (DismissDirection direction){
            exercises.remove(exercise);
            setState((){});
          },
          child: ListTile(
            tileColor: (lastActiveExercise == exercise) ? Theme.of(context).colorScheme.inversePrimary : null,
            title: Text(exercise.name),
            onTap: (){
              lastActiveExercise = exercise;
              Navigator.pushNamed(context, '/exercise/perform', arguments: exercise);
              if(mounted){
                setState((){});
              }
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
