import 'package:flutter/material.dart';
import 'package:trackrep/widgets/number_picker.dart';
import 'package:trackrep/widgets/timer.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {


  int currentPage = 0;
  List<Widget> states =  [];

  @override
  void initState(){
    super.initState();
    // normal workout
    states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 1), onSkip: nextPage, text: "Mountain Climbers"));
    states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 1), onSkip: nextPage, text: "Jumping Jacks"));
    states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 1), onSkip: nextPage));


    for(int i = 0; i < 4; i++){
      states.add(NumberPicker(fromNumber: 0, toNumber: 12, text: "Shrimp Squat", onChoosen: nextPage));
      states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 3), onSkip: nextPage));
    }

    for(int i = 0; i < 4; i++){
      states.add(NumberPicker(fromNumber: 0, toNumber: 12, text: "Wide Pull Up +14kg", onChoosen: nextPage));
      states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 3), onSkip: nextPage));
    }

    for(int i = 0; i < 4; i++){
      states.add(NumberPicker(fromNumber: 0, toNumber: 12, text: "V-Raise", onChoosen: nextPage));
      states.add(NumberPicker(fromNumber: 0, toNumber: 12, text: "Pseudo Push Up", onChoosen: nextPage));
      states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 1, seconds: 30), onSkip: nextPage));
    }

    states.add(NumberPicker(fromNumber: 0, toNumber: 12, text: "Wall Plank March", onChoosen: nextPage));

    // stretching
    states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 1), onSkip: nextPage, text: "Reach Down"));
    states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 1), onSkip: nextPage, text: "Stretch Back"));
    states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 2), onSkip: nextPage, text: "Wall Sit"));
    states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 1), onSkip: nextPage, text: "Shoulder on Knee"));
    states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 1), onSkip: nextPage, text: "Shoulder Standing"));
    states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 1), onSkip: nextPage, text: "Hip Thrusters"));
    states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 1), onSkip: nextPage, text: "Half Bridge"));
  }

  void nextPage(){
    currentPage++;
    if(currentPage >= states.length) currentPage = states.length-1;
    setState((){});
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("TestPage"),
      ),
      body: states[currentPage]
    );
  }
}
