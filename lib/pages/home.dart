import 'package:flutter/material.dart';
import 'package:trackrep/widgets/timer.dart';

import 'package:trackrep/services/database.dart';
import 'package:trackrep/models/exercise.dart';

import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: IconButton(icon: const Icon(Icons.list), onPressed: (){
          Navigator.pushNamed(context, "/exercise_log/list");
        }),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.fitness_center_outlined), onPressed: (){
            Navigator.pushNamed(context, "/exercise/list");
          }),
        ]
      ),
      body: Timer(finishTime: const Duration(minutes: 1), onFinish: (int x){}, skipable: true, onSkip: (int x){}),
    );
  }

  void loadData()async{

    //List<Permission> permissions = [Permission.storage];
    //await permissions.request();
    MediaStore store = MediaStore();
    MediaStore.appFolder = 'trackrep';
    Directory temp = await getTemporaryDirectory();
    File file = File('${temp.path}/test.txt');
    await file.writeAsString('hello world');
    await file.writeAsString('hello world2', mode: FileMode.append);
    file.create();
    await store.saveFile(dirType: DirType.download, dirName: DirName.download, tempFilePath: file.path, relativePath: FilePath.root);

    // exercises michael
    await DatabaseConnector.insertExercise(Exercise(name: 'Shrimp Squat'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Wall Hand Stand Push Up'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Side Raises + 14kg'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Close Chin Up + 14kg'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Wall Plank March', type: Exercise.timedEventType));


    await DatabaseConnector.insertExercise(Exercise(name: 'Wide Pull Up + 14kg'));
    await DatabaseConnector.insertExercise(Exercise(name: 'V-Raise'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Pseudo Push Up'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Wall Plank March + 14kg', type: Exercise.timedEventType));

    await DatabaseConnector.insertExercise(Exercise(name: 'Pistol Squat'));

    //exercies kerstin
    await DatabaseConnector.insertExercise(Exercise(name: 'Assisted Pistol Squat'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Push Up'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Windshield Wipers'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Chin Up - 35lbs'));
    await DatabaseConnector.insertExercise(Exercise(name: 'One Legged Plank R', type: Exercise.timedEventType));

    await DatabaseConnector.insertExercise(Exercise(name: 'Pull Up - 35lbs'));
    await DatabaseConnector.insertExercise(Exercise(name: 'One Legged Plank L', type: Exercise.timedEventType));


    //exercises stretching
    await DatabaseConnector.insertExercise(Exercise(name: 'Reach Down', type: Exercise.timedEventType));
    await DatabaseConnector.insertExercise(Exercise(name: 'Bend Back', type: Exercise.timedEventType));
    await DatabaseConnector.insertExercise(Exercise(name: 'Hip Stretch', type: Exercise.timedEventType));
    await DatabaseConnector.insertExercise(Exercise(name: 'Shoulder Stretch Kneeling', type: Exercise.timedEventType));
    await DatabaseConnector.insertExercise(Exercise(name: 'Shoulder Stretch Standing', type: Exercise.timedEventType));
    await DatabaseConnector.insertExercise(Exercise(name: 'Hip Thrusters'));
    await DatabaseConnector.insertExercise(Exercise(name: 'Half Bridge'));
  }
}
