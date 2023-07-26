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
    states.add(NumberPicker(fromNumber: 0, toNumber: 12, text: "Wall Hand Stand Push Up", onChoosen: nextPage));
    states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 3), onSkip: nextPage));
    states.add(NumberPicker(fromNumber: 0, toNumber: 12, text: "Wall Hand Stand Push Up", onChoosen: nextPage));
    states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 3), onSkip: nextPage));
    states.add(NumberPicker(fromNumber: 0, toNumber: 12, text: "Wall Hand Stand Push Up", onChoosen: nextPage));
    states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 3), onSkip: nextPage));
    states.add(NumberPicker(fromNumber: 0, toNumber: 12, text: "Wall Hand Stand Push Up", onChoosen: nextPage));
    states.add(Timer(resetable: false, skipable: true, finishTime: const Duration(minutes: 3), onSkip: nextPage));
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
