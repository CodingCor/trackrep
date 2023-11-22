import 'package:flutter/material.dart';
import 'package:trackrep/widgets/timer.dart';

import 'package:trackrep/services/database.dart';
import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/models/workout.dart';
import 'package:trackrep/models/exercise_order.dart';

import 'dart:math';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: IconButton(icon: const Icon(Icons.list), onPressed: (){
          Navigator.pushNamed(context, "/exercise_log/list");
        }),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.fitness_center_outlined), onPressed: (){
            Navigator.pushNamed(context, "/workout/list");
          }),
          IconButton(icon: const Icon(Icons.fitness_center_outlined), onPressed: (){
            Navigator.pushNamed(context, "/exercise/list");
          }),
        ]
      ),
      body: Timer(finishTime: const Duration(minutes: 1), onFinish: (int x){}, skipable: true, onSkip: (int x){}),
    );
  }

  void loadData()async{

    // exercises michael
    await DatabaseConnector.insertExercise(Exercise(name: 'Shrimp Squat'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Wall Hand Stand Push Up'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Side Raises + 14kg'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Close Chin Up + 14kg'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Wall Plank March', type: Exercise.timedEventType));


    await DatabaseConnector.insertExercise(Exercise(name: 'Wide Pull Up + 14kg'));
    await DatabaseConnector.insertExercise(Exercise(name: 'V-Raise'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Pseudo Push Up'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Wall Plank March + 14kg', type: Exercise.timedEventType));

    await DatabaseConnector.insertExercise(Exercise(name: 'Pistol Squat'));

    //exercies kerstin
    await DatabaseConnector.insertExercise(Exercise(name: 'Assisted Pistol Squat'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Push Up'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Windshield Wipers'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Chin Up - 35lbs'));
    await DatabaseConnector.insertExercise(Exercise(name: 'One Legged Plank R', type: Exercise.timedEventType));

    await DatabaseConnector.insertExercise(Exercise(name: 'Pull Up - 35lbs'));
    await DatabaseConnector.insertExercise(Exercise(name: 'One Legged Plank L', type: Exercise.timedEventType));


    //exercises stretching
    await DatabaseConnector.insertExercise(Exercise(name: 'Reach Down', type: Exercise.timedEventType));
    await DatabaseConnector.insertExercise(Exercise(name: 'Bend Back', type: Exercise.timedEventType));
    await DatabaseConnector.insertExercise(Exercise(name: 'Hip Stretch', type: Exercise.timedEventType));
    await DatabaseConnector.insertExercise(Exercise(name: 'Shoulder Stretch Kneeling', type: Exercise.timedEventType));
    await DatabaseConnector.insertExercise(Exercise(name: 'Shoulder Stretch Standing', type: Exercise.timedEventType));
    await DatabaseConnector.insertExercise(Exercise(name: 'Hip Thrusters'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Half Bridge'));

    // rest time
    await DatabaseConnector.insertExercise(Exercise(name: 'Rest Time', type: Exercise.restTime));

    //await DatabaseConnector.rawExecute("drop table exerciseorder;");
    List<Exercise> exercises = await DatabaseConnector.getExercises();
    List<Workout> workouts = await DatabaseConnector.getWorkouts();
    if(workouts.isNotEmpty){
      Random rng = Random();
      await DatabaseConnector.fillWorkout(workouts[0], [
        exercises.elementAt(rng.nextInt(exercises.length - 1)),
        exercises.elementAt(rng.nextInt(exercises.length - 1)),
        exercises.elementAt(rng.nextInt(exercises.length - 1)),
        exercises.elementAt(rng.nextInt(exercises.length - 1)),
        exercises.elementAt(rng.nextInt(exercises.length - 1)),
        exercises.elementAt(rng.nextInt(exercises.length - 1)),
      ]);
    }
    List<ExerciseOrder> exerciseOrder = await DatabaseConnector.getExercisesForWorkout(workouts[0]);
    for(ExerciseOrder exercise in exerciseOrder){
      debugPrint("${exercise.workout} - ${exercise.order} - ${exercise.exercise}");
    }

    //await DatabaseConnector.rawQuery('select * from exercise where id in (select exercise from exerciseorder where workout = 1);');
    await DatabaseConnector.rawQuery('select * from exerciseorder join exercise on exerciseorder.exercise = exercise.id where workout = 1;');
  }



}
