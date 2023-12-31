import 'package:flutter/material.dart';
import 'package:trackrep/pages/home.dart';
import 'package:trackrep/pages/testpage.dart';
import 'package:trackrep/pages/exercise_list.dart';
import 'package:trackrep/pages/exerciselog_list.dart';
import 'package:trackrep/pages/perform_exercise.dart';
import 'package:trackrep/pages/workout_list.dart';
import 'package:trackrep/pages/workout_exercise.dart';
import 'package:trackrep/pages/landing_page.dart';
import 'package:trackrep/pages/timer_page.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/home' : (context) => const MyHomePage(title: "TrackRep"),
  '/landing' : (context) => const LandingPage(title: "TrackRep"),
  '/timer' : (context) => const TimerPage(),
  '/test' : (context) => const TestPage(),
  '/exercise/list' : (context) => const ExerciseListPage(),
  '/exercise_log/list' : (context) => const ExerciseLogList(),
  '/exercise/perform' : (context) => const PerformExercise(),
  '/workout/list' : (context) => const WorkoutListPage(),
  '/workout/exercises' : (context) => const WorkoutExercisesPage(),
};

ThemeData data = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
  useMaterial3: true,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackRep',
      theme: data,
      routes: routes,
      initialRoute: '/landing',
    );
  }
}

