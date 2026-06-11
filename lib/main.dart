import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'Screens/basicScreen.dart';


void main() async{
  await Hive.initFlutter();
  await Hive.openBox('taskBox');
  await Hive.openBox('doneBox');
  await Hive.openBox('userBox');

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => TasksApp(),),
  );
}

class TasksApp extends StatelessWidget {
  const TasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home : TasksHomeScreen(),
    );
  }
}
