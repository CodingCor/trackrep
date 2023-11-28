import 'package:flutter/material.dart';
import 'package:trackrep/widgets/timer.dart';

class TimerPage extends StatelessWidget{
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Stopwatch"),
      ),
      body: const Timer(finishTime: Duration(minutes: 1)),
    );
  }
}
