import 'package:flutter/material.dart';

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  
  Stopwatch stopwatch = Stopwatch();

  @override 
  void initState(){
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(stopwatch.isRunning){
      resetStateIn(const Duration(milliseconds: 100));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Timer Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(getTimeString()),
            IconButton(
              icon: const Icon(Icons.start),
              onPressed: (){
                restartStopwatch();
              },
            ),
          ]
        ),
      ),
    );
  }

  void restartStopwatch(){
    if(stopwatch.isRunning){
      stopwatch.stop();
    }else{
      stopwatch.start();
    }
    setState((){});
  }

  void resetStateIn(Duration dur){
    Future.delayed(dur).then( (void para){
      if(mounted){
        setState((){}); 
      }
    });
  }

  String getTimeString(){

    String milliseconds = (stopwatch.elapsed.inMilliseconds % 1000).toString();
    if(milliseconds.length > 2){
      milliseconds = milliseconds.substring(0, 2);
    }
    milliseconds = milliseconds.padLeft(2, '0');

    String seconds = (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
    String minutes = (stopwatch.elapsed.inMinutes).toString().padLeft(2, '0');

    return "$minutes:$seconds:$milliseconds";
  }

}
