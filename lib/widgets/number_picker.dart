import 'package:flutter/material.dart';

class NumberPicker extends StatefulWidget {
  const NumberPicker({super.key});

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker>{

  int selectedItem = 0;
  List<Widget> items = [];
  
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
    return selector();
  }

  Widget selectorBody(){
    return 
    Column(
      children: <Widget>[
        const Spacer(),
        Expanded( 
          flex: 2, 
          child: Padding(
            padding: const EdgeInsets.all(12.0), 
            child: selector(),
          )
        ),
        const Spacer(),
      ],
    );
  }

  Widget selector(){
    return Row(
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
    );
  }

  Card card(Color color, int index){
    return Card(
      color: color,
      child: Center(child: Text(index.toString(), style: Theme.of(context).textTheme.displayMedium)),
    );
  }
}

