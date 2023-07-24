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
    for(int i=0; i < elementCount; i++){
      if(i == selectedItem){
        items.add(item(Colors.lightBlue, i));
      }else{
        items.add(item(Colors.white, i));
      }
    }
    return newTest();
  }
  
  PageController controller = PageController(viewportFraction: 1/4, initialPage: 50);
  Widget newTest(){
    return PageView(
      controller: controller,
      scrollDirection: Axis.vertical,
      children: items,
    );
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

  Widget item(Color color, int index){
    return TextButton(
      onPressed: (){},
      child: Text(index.toString(), style: Theme.of(context).textTheme.displayMedium),
    );
  }
}

