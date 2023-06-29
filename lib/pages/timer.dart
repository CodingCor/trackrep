import 'package:flutter/material.dart';

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {

  void resetStateIn(Duration dur){
    Future.delayed(dur).then( (void para){
      if(mounted){
        debugPrint("Reset State");
        setState((){}); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    resetStateIn(const Duration(seconds: 1));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Timer Example"),
      ),
      body: Center(
        child: Text(DateTime.now().toString()),
      ),
    );
  }
}
