import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

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
            Text(getTimeString(), style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: startOrPause,
                  child:  Text((stopwatch.isRunning) ? "Stop" : "Start"),
                ),
                (!stopwatch.isRunning) ? TextButton(
                  onPressed: resetWatch,
                  child: const Text("Reset"),
                ) : Container(),
              ]
            ),
          ]
        ),
      ),
    );
  }

  ///
  /// Widgets
  ///

  Widget timerText(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(getMinutes(), style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
        ),  
        Expanded(
          flex: 1,
          child: Text(":", style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
        ),  
        Expanded(
          flex: 2,
          child: Text(getSeconds(), style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
        ),  
        Expanded(
          flex: 1,
          child: Text(":", style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
        ),  
        Expanded(
          flex: 2,
          child: Text(getMilliseconds(), style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
        ),  
        const Spacer(),
      ]
    );
  }

  ///
  /// MEMBER FUNCTIONS
  ///

  void startOrPause(){
    if(stopwatch.isRunning){
      stopwatch.stop();
      Wakelock.disable();
    }else{
      stopwatch.start();
      Wakelock.enable();
    }
    setState((){});
  }

  void resetWatch(){
    if(stopwatch.isRunning) return;

    stopwatch.stop();
    stopwatch.reset();

    setState((){});
  }

  void resetStateIn(Duration dur){
    Future.delayed(dur).then( (void para){
      if(mounted){
        setState((){}); 
      }
    });
  }

  String getMinutes(){
    return (stopwatch.elapsed.inMinutes).toString().padLeft(2, '0');
  }

  String getSeconds(){
    return (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
  }

  String getMilliseconds(){
    String milliseconds = (stopwatch.elapsed.inMilliseconds % 1000).toString();
    if(milliseconds.length > 2){
      milliseconds = milliseconds.substring(0, 2);
    }
    milliseconds = milliseconds.padLeft(2, '0');
    return milliseconds;
  }

  String getTimeString(){

    String milliseconds = (stopwatch.elapsed.inMilliseconds % 1000).toString();
    if(milliseconds.length > 2){
      milliseconds = milliseconds.substring(0, 2);
    }
    milliseconds = milliseconds.padLeft(2, '0');

    String seconds = (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
    String minutes = (stopwatch.elapsed.inMinutes).toString().padLeft(2, '0');

    return "$minutes:$seconds.$milliseconds";
  }

}
