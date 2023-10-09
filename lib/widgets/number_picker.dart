import 'package:flutter/material.dart';

class NumberPicker extends StatefulWidget {
  final int fromNumber; 
  //TODO: intial item is not working correctly
  // check this with following values:
  // from: 2
  // to: 20
  // initial: 12 (is shown as 14 though)
  final int? initalItem;
  final int toNumber;
  final String text;
  final void Function(int repetition) onChoosen; //< onPicked Callback
  const NumberPicker({super.key, this.fromNumber=0, this.toNumber=100, this.initalItem, required this.text, required this.onChoosen});

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker>{

  late final int itemCount;
  List<Widget> items = [];
  late PageController controller;
  
  @override
  void initState(){
    super.initState();
    itemCount = (widget.toNumber - widget.fromNumber);
    controller = PageController(viewportFraction: 1/4, initialPage: (itemCount-(widget.initalItem ?? 0)));
  }
  
  @override
  Widget build(BuildContext context) {
    items.clear();
    for(int i = widget.toNumber; i >= widget.fromNumber; i--){
        items.add(item(i));
    }

    return layoutVertical();
  }
  
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
            child: Stack(
              children: [
                Align(alignment: const FractionalOffset(0.00, 0.50), child: Divider(thickness: 1, color: Theme.of(context).colorScheme.inversePrimary)),
                layoutHorizontal(),
              ]
            ),
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
        Expanded(flex: 2, child: Text(widget.text, style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center)),
        Expanded(flex: 1, child: selector(),),
      ]
    );
  }

  Widget item(int index){
    return TextButton(
      onPressed: (){
        widget.onChoosen(index);
      },
      child: Text(index.toString(), style: Theme.of(context).textTheme.displayMedium),
    );
  }
}

