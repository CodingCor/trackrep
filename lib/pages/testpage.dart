import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  int selectedItem = 0;
  @override
  Widget build(BuildContext context) {

    int elementCount = 100;
    List<Widget> items = [];
    for(int i=0; i < elementCount; i++){
      if(i == selectedItem){
        items.add(card(Colors.lightBlue, i));
      }else{
        items.add(card(Colors.white, i));
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("TestPage"),
      ),
      body: ListWheelScrollView(
        itemExtent: 120.0,
        perspective: 0.000000000001,
        children: items,
        onSelectedItemChanged: (int value){
          setState((){
            selectedItem = value;
          });
        },
      ),
    );
  }

  Card card(Color color, int index){
    return Card(
      color: color,
      child: SizedBox(
        width: 200.0,
        child: Center(child: Text(index.toString(), style: Theme.of(context).textTheme.displayMedium)),
      ),
    );
  }
}
