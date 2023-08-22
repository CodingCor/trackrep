import 'package:flutter/material.dart';
import 'package:trackrep/widgets/timer.dart';
import 'package:trackrep/services/database.dart';

import 'package:trackrep/models/exercise.dart';

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
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.dataset), onPressed: (){
            Navigator.pushNamed(context, "/test");
          }),
        ]
      ),
      body: Timer(finishTime: const Duration(minutes: 1), onFinish: (){print("Finished");}, skipable: true, onSkip: (){print("Skip");}),
    );
  }

  void loadData()async{
    await DatabaseConnector.init();
    await DatabaseConnector.insertExercise(Exercise(name: 'Push Up'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Wall Hand Stand Push Up'));
    await DatabaseConnector.insertExercise(Exercise(name: 'V - Raise'));

    Exercise? exc = await DatabaseConnector.getExercise(1);
    if(exc != null) debugPrint("${exc.id}|${exc.name}");
  }
}
