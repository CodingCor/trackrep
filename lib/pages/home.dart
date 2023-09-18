import 'package:flutter/material.dart';
import 'package:trackrep/widgets/timer.dart';

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
          IconButton(icon: const Icon(Icons.fitness_center_outlined), onPressed: (){
            Navigator.pushNamed(context, "/exercises");
          }),
        ]
      ),
      body: Timer(finishTime: const Duration(minutes: 1), onFinish: (){print("Finished");}, skipable: true, onSkip: (){print("Skip");}),
    );
  }

  void loadData()async{
  }
}
