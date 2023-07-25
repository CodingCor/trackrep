import 'package:flutter/material.dart';
import 'package:trackrep/widgets/number_picker.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("TestPage"),
      ),
      body: NumberPicker(text: "Pseudo Push Up", initalItem: 12, toNumber: 20, fromNumber: 2, onChoosen: (){print("return");}),
    );
  }
}
