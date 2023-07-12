import 'package:flutter/material.dart';
import 'package:trackrep/widgets/timer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.dataset), onPressed: (){
            Navigator.pushNamed(context, "/test");
          }),
        ]
      ),
      body: const Column(
        children: <Widget>[
          Timer(finishTime: Duration(minutes: 1)),
          //Timer(pauseable: false,),
        ]
      ),
    );
  }
}
