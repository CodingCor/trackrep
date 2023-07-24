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
    for(int i = elementCount; i >= 0; i--){
      if(i == selectedItem){
        items.add(item(Colors.lightBlue, i));
      }else{
        items.add(item(Colors.white, i));
      }
    }
    return layoutVertical();
  }
  
  PageController controller = PageController(viewportFraction: 1/4, initialPage: (100-12));
  Widget selector(){
    return PageView(
      controller: controller,
      scrollDirection: Axis.vertical,
      children: items,
    );
  }


  Widget layoutVertical(){
    return 
    Column(
      children: <Widget>[
        const Spacer(),
        Expanded( 
          flex: 2, 
          child: Padding(
            padding: const EdgeInsets.all(12.0), 
            child: layoutHorizontal(),
          )
        ),
        const Spacer(),
      ],
    );
  }

  Widget layoutHorizontal(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 2, child: Text("Push Ups", style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center)),
        Expanded(flex: 1, child: 
          selector(),
        ),
      ]
    );
  }

  Widget item(Color color, int index){
    return TextButton(
      onPressed: (){
        print("Pressed: $index");
      },
      child: Text(index.toString(), style: Theme.of(context).textTheme.displayMedium),
    );
  }
}

