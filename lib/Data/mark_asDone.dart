import 'package:hive/hive.dart';

void markAsDone({
  required int index,
  required String taskTitle,
  required Box doneBox,
  required Box taskBox,
})
{
  doneBox.add(taskTitle);
  taskBox.deleteAt(index);
}