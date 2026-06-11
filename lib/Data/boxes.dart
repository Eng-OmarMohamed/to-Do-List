import 'package:hive/hive.dart';

final Box taskBox = Hive.box('taskBox');
final Box doneBox = Hive.box('doneBox');
final Box userBox = Hive.box('userBox');