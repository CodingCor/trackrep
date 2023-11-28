import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget{
  final String title;
  const LandingPage({super.key, required this.title});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: ListView(
        children: <Widget>[
          tile(context, "Exercises",  "Add and perform Exercises",      '/exercise/list'),
          tile(context, "Workouts",   "Add and perform Workouts",       '/workout/list'),
          tile(context, "Log",        "View past performed Exercises",  '/exercise_log/list'),
          tile(context, "Stopwatch",  "A simple Stopwatch",             '/timer'),
        ]
      ) 
    );
  }

  Widget tile(BuildContext context, String title, String description, String route){
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      onTap: (){
        Navigator.pushNamed(context, route);
      }
    );
  }
}
