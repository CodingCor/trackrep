import 'package:flutter/material.dart';
import 'package:trackrep/widgets/number_picker.dart';
import 'package:trackrep/widgets/timer.dart';

import 'package:trackrep/models/exercise.dart';
import 'package:trackrep/services/database.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {


  int currentPage = 0;
  List<Widget> states =  [];
  List<Exercise> exercises = [];

  @override
  void initState(){
    super.initState();
    loadData();
  }


  void nextPage(){
    currentPage++;
    if(currentPage >= states.length) currentPage = states.length-1;
    setState((){});
  }


  @override
  Widget build(BuildContext context) {

    if(states.isEmpty){
      return const CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("TestPage"),
      ),
      body: states[currentPage]
    );
  }

  void loadData()async{
    exercises = await DatabaseConnector.getExercises();

    //TODO: some exercises require a timer to appear
    //TODO: maxe exercise type timer for timed exercise
    performExercise([exercises[0]], 60, const Duration(minutes: 0), 1, const Duration(minutes: 0));
    performExercise([exercises[1]], 60, const Duration(minutes: 0), 1, const Duration(minutes: 0));

    performExercise([exercises[2], exercises[2]], 12, const Duration(minutes: 3), 4, const Duration(minutes: 3));
    performExercise([exercises[3]], 12, const Duration(minutes: 3), 4, const Duration(minutes: 1, seconds: 30));

    performExercise([exercises[4], exercises[5]], 12, const Duration(minutes: 1, seconds: 30), 4, const Duration(minutes: 1, seconds: 30));
    
    if(mounted){
      setState((){});
    }
  }

  void performExercise(List<Exercise> exercises, int target, Duration restBetween, int sets,Duration restAfter){
    for(int i=0; i<sets; i++){
      for(Exercise exercise in exercises){
        if(exercise.type == 'R'){
          states.add(NumberPicker(fromNumber: 0, toNumber: target, text: exercise.name, onChoosen: nextPage));
        }else if(exercise.type == 'T'){
          states.add(Timer(resetable: false, skipable: true, finishTime: Duration(seconds: target), onSkip: nextPage, text: exercise.name,));
        }
      }
      if(restBetween.inMicroseconds == 0) continue;
      states.add(Timer(resetable: false, skipable: true, finishTime: restBetween, onSkip: nextPage,));
    }
    if(sets<=0) return;
    if(restAfter.inMicroseconds == 0) return;

    states.removeLast();    
    states.add(Timer(resetable: false, skipable: true, finishTime: restAfter, onSkip: nextPage));
  }
}
