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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("TestPage"),
      ),
      body: body(),
    );
  }

  Widget body(){
    int elementCount = 100;
    List<Widget> items = [];
    for(int i=0; i < elementCount; i++){
      if(i == selectedItem){
        items.add(card(Colors.lightBlue, i));
      }else{
        items.add(card(Colors.white, i));
      }
    }
    return 
    Column(
      children: <Widget>[
        const Spacer(),
        Expanded( flex: 2, child: Padding(
          padding: const EdgeInsets.all(12.0), 
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 2, child: Text("Push Ups", style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center)),
              Expanded(flex: 1, child: 
                ListWheelScrollView(
                  itemExtent: 80.0,
                  perspective: 0.000000000001,
                  children: items,
                  onSelectedItemChanged: (int value){
                    setState((){
                      selectedItem = value;
                    });
                  },
                ),
              ),
            ]
          )
        )),
        const Spacer(),
      ],
    );
  }

  Card card(Color color, int index){
    return Card(
      color: color,
      child: Center(child: Text(index.toString(), style: Theme.of(context).textTheme.displayMedium)),
    );
  }
}
