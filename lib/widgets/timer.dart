import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

class Timer extends StatefulWidget {
  
  final bool resetable;
  final bool pauseable;
  final Duration? finishTime;

  const Timer({
    super.key, 
    this.resetable = true,
    this.pauseable = true,
    this.finishTime
  });

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
    return Expanded( child: timer());
  }

  ///
  /// Widgets
  ///
  //
  Widget timer(){
    return Stack(
      children: <Widget>[
        colorBackground(),
        timerWidget(),
        const Center(child: VerticalDivider(thickness: 1)),
        const Center(child: Divider(thickness: 1)),
      ],
    );
  }

  Widget colorBackground(){

    int maxheight = MediaQuery.of(context).size.height.toInt();

    int factor = widget.finishTime?.inMilliseconds ?? 1000 * 60;

    int flex1 = ((maxheight / factor) * (stopwatch.elapsed.inMilliseconds % (factor))).toInt();
    int flex2 = maxheight - flex1;

    return Column(
      children: <Widget> [
        Expanded(
          flex: flex2,
          child: Container(),
        ),
        Expanded(
          flex: flex1 ,
          child: Container(
            color: Colors.lightBlue[200],
          ),
        ),
      ]
    ); 
  }

  Widget timerWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Center(child: Text(getTimeString(stopwatch.elapsed), style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center)),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: stopWatchActions(),
          ),
        ),
      ]
    );
  }

  List<Widget> stopWatchActions(){
    List<Widget> actions = [];

    // start 
    if(!stopwatch.isRunning){
      actions.add(
        IconButton(
          iconSize: (IconTheme.of(context).size ?? 1.0) * 2.0,
          onPressed: startOrPause,
          icon:  const Icon(Icons.play_arrow_outlined),
        ),
      );
    }
    // pause
    if(stopwatch.isRunning && widget.pauseable){
      actions.add(
        IconButton(
          iconSize: (IconTheme.of(context).size ?? 1.0) * 2.0,
          onPressed: startOrPause,
          icon:  const Icon(Icons.pause_outlined),
        ),
      );
    }
    // reset
    if(!stopwatch.isRunning && stopwatch.elapsed.inMilliseconds != 0 && widget.resetable){
      actions.add(
        IconButton(
          iconSize: (IconTheme.of(context).size ?? 1.0) * 2.0,
          onPressed: resetWatch,
          icon: const Icon(Icons.refresh_outlined),
        )
      );
    }
    return actions;
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

  static String getTimeString(Duration time){

    String milliseconds = (time.inMilliseconds % 1000).toString();
    if(milliseconds.length > 2){
      milliseconds = milliseconds.substring(0, 2);
    }
    milliseconds = milliseconds.padLeft(2, '0');

    String seconds = (time.inSeconds % 60).toString().padLeft(2, '0');
    String minutes = (time.inMinutes).toString().padLeft(2, '0');

    return "$minutes:$seconds.$milliseconds";
  }

}
