import 'package:flutter/material.dart';
import 'package:trackrep/pages/home.dart';
import 'package:trackrep/pages/testpage.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/home' : (context) => const MyHomePage(title: "TrackRep"),
  '/test' : (context) => const TestPage(),
};

ThemeData data = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
  useMaterial3: true,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackRep',
      theme: data,
      routes: routes,
      initialRoute: '/home',
    );
  }
}

