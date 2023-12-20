import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

///
/// \brief  controllable timer widget
///
/// This widget is a controllable Timer Widget. 
/// The Timer can be started, stopped and reset if not specified otherwise.
/// A finishtime can be provided to give a visual indication of the expedted 
/// end time;
///
/// This widget expands to it's parents widget size.
///
class Timer extends StatefulWidget {
  
  final bool resetable; //< is this timer resetable
  final bool pauseable; //< is this timer pausable
  final bool skipable; //< is this timer skipable
  final Duration? finishTime; //< does this timer have a finish indication
  final String? text; //< text to show on the screen
  final void Function(int seconds)? onFinish; //< callback on finishtime
  final void Function(int seconds)? onSkip; //< callback on skip

  const Timer({
    super.key, 
    this.resetable = true,
    this.pauseable = true,
    this.skipable = false,
    this.finishTime,
    this.text,
    this.onFinish,
    this.onSkip,
  });

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> with AutomaticKeepAliveClientMixin{
  
  Stopwatch stopwatch = Stopwatch();
  bool onFinishExecuted = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(stopwatch.isRunning){
      resetStateIn(const Duration(milliseconds: 100));
    }
    return timer();
  }

  ///
  /// \brief  stacks the background and the timer widget
  ///
  Widget timer(){
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        colorBackground(),
        timerWidget(),
        //const Align(alignment: FractionalOffset(0.25, 0.00), child: VerticalDivider(thickness: 1)),
        //const Align(alignment: FractionalOffset(0.50, 0.00), child: VerticalDivider(thickness: 1)),
        //const Align(alignment: FractionalOffset(0.75, 0.00), child: VerticalDivider(thickness: 1)),
        //const Align(alignment: FractionalOffset(0.00, 0.25), child:         Divider(thickness: 1)),
        //const Align(alignment: FractionalOffset(0.00, 0.50), child:         Divider(thickness: 1)),
        //const Align(alignment: FractionalOffset(0.00, 0.75), child:         Divider(thickness: 1)),
      ],
    );
  }

  ///   
  /// \brief  this method creates a 2 colored background
  ///
  /// The ammount of color depends on the elapsed time in proportion to the
  /// specified finish time.
  ///
  /// \return returns a column containing 2 colored containers
  ///
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
            color: Theme.of(context).colorScheme.inversePrimary ,
          ),
        ),
      ]
    ); 
  }

  ///
  /// \brief  contains the logic and ui of the timer itself
  ///
  /// this widget contains the time text and all controll icons for the timer.
  ///
  /// \return Widget containing the timer
  ///
  Widget timerWidget(){
    List<Widget> timerWidgets = [];
    timerWidgets.add(
      Text(getTimeString(stopwatch.elapsed), style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
    );

    if(widget.finishTime != null){
      timerWidgets.add(SizedBox(width: 100, child: Divider(thickness: 2.0, color: Theme.of(context).colorScheme.onBackground)));
      timerWidgets.add(Text(getTimeString(widget.finishTime!), style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center ,
      children: <Widget>[
        Expanded(
          child: Center(child: Text(textAlign: TextAlign.center, widget.text ?? "", style: Theme.of(context).textTheme.displayMedium)),
        ),
        Expanded( child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: timerWidgets
        )),
        Expanded( child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: stopWatchActions(),
        )),
      ]
    );
  }

  ///
  /// \brief  contains a list of all available timer actions
  ///
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

    if(widget.skipable){
      actions.add(
        IconButton(
          iconSize: (IconTheme.of(context).size ?? 1.0) * 2.0,
          onPressed: (widget.onSkip == null) ? null : (){
            int elapsedSeconds = stopwatch.elapsed.inSeconds;
            resetWatch();
            widget.onSkip!(elapsedSeconds);
          },
          icon: const Icon(Icons.skip_next_outlined),
        )
      );
    }
    return actions;
  }


  ///
  /// MEMBER FUNCTIONS
  ///

  ///
  /// \brief start or pause the timer
  /// 
  /// depending on the running status the timer will be stopped or started
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

  ///
  /// \brief reset the timer if it is not currently running
  ///
  void resetWatch(){

    stopwatch.stop();
    stopwatch.reset();
    onFinishExecuted = false;

    if(mounted)setState((){});
  }

  ///
  /// \brief  reset the State of the Widget after Duration has elapsed
  ///
  /// \param  Duration to wait before setState
  ///
  void resetStateIn(Duration dur){
    Future.delayed(dur).then( (void para){
      if(mounted){
        if(widget.finishTime != null && finishTimeReached()){ //invoke onFinish function
          if(widget.onFinish != null && !onFinishExecuted){
            onFinishExecuted = true;
            widget.onFinish!(dur.inSeconds);
          }
        }
        setState((){}); 
      }
    });
  }

  ///
  /// \brief  returns true if the finish time has been exceeded
  ///
  /// \return returns true if finish time is exceeded
  ///
  bool finishTimeReached(){
    if(widget.finishTime != null && widget.finishTime! <= stopwatch.elapsed) return true;
    return false;
  }

  ///
  /// \brief  transform a duration to a printable string
  ///
  /// \param  Duration to transform
  ///
  /// \return formated string
  ///
  static String getTimeString(Duration time){

    String milliseconds = (time.inMilliseconds % 1000).toString();
    if(milliseconds.length > 2){
      milliseconds = milliseconds.substring(0, 2);
    }
    milliseconds = milliseconds.padLeft(2, '0');

    String seconds = (time.inSeconds % 60).toString().padLeft(2, '0');
    String minutes = (time.inMinutes).toString().padLeft(2, '0');

    return '$minutes:$seconds.$milliseconds';
  }


}
