import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  @override
  Widget build(BuildContext context) {
    int elementCount = 100;
    List<Widget> items = [];
    for(int i=0; i < elementCount; i++){
      items.add(Card(child: Text(i.toString(), style: Theme.of(context).textTheme.displayMedium)));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("TestPage"),
      ),
      body: ListWheelScrollView(
        itemExtent: 100.0,
        children: items,
      ),
    );
  }
}
