import 'package:flutter/material.dart';

void addNewTask(
    {
      required dynamic taskBox,
      required BuildContext context,
      required TextEditingController taskController,
    })
{
  if (taskController.text.isNotEmpty) {
    taskBox.add(taskController.text.trim());
    taskController.clear();
    Navigator.pop(context);
  }
}