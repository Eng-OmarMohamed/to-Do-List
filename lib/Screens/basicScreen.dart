import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import '/core/colors.dart';
import '/Widgets/doneSection.dart';
// Data
import '/Data/add_new_task.dart';
import '/Data/mark_asDone.dart';
import '/Data/pick_profile_image.dart';
import '/Data/boxes.dart';

class TasksHomeScreen extends StatefulWidget {
  const TasksHomeScreen({super.key});

  @override
  State<TasksHomeScreen> createState() => _TasksHomeScreenState();
}

class _TasksHomeScreenState extends State<TasksHomeScreen> {

  final TextEditingController _taskController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final hourNow =  DateTime.now().hour % 12 ;
  late final timeNow = hourNow ;
  final minuteNow = DateTime.now().minute;
  final yearsNow = DateTime.now().year;
  final monthNow = DateTime.now().month;
  final dayNow = DateTime.now().day;
  @override
  Widget build(BuildContext context) {
    String? imagePath = userBox.get('profilePath');
    return Scaffold(
      backgroundColor: AppColor.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColor.bgAppBar,
        elevation: 0,
        title: Row(
          children: [
            Text(
              "Task's",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Lottie.asset(
              'assets/animations/ropotrocket.json',
              width: 70,
              height: 70,
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () =>
                pickProfileImage(
                  picker: _picker, userBox: userBox, setState: setState,),
            child: Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColor.bgProfilePhoto,
                backgroundImage: imagePath != null
                    ? FileImage(File(imagePath))
                    : null,
                child: imagePath == null ? Icon(
                    Icons.add_a_photo, size: 18, color: AppColor.bg_iconProfilePhoto) : null,
              ),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box box, child) {
          if (box.isEmpty && doneBox.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/robot.json',
                    height: 180,
                  ),
                  SizedBox(height: 10),
                  Text("Has Tasks not added anything yet?!\n        "
                      "     I'm waiting, add now..", style: TextStyle(
                      color: AppColor.centerScreen, fontSize: 16,
                      fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            );
          }
          return ListView(
            padding: EdgeInsets.all(15),
            children: [
              if (box.isNotEmpty) ...[
                Row(
                  children: [
                    Text(
                      "Active Tasks",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.Active,
                      ),
                    ),

                    SizedBox(width: 8),

                    Lottie.asset(
                      'assets/animations/active.json',
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final taskTitle = box.getAt(index).toString();
                    return Card(
                      color: AppColor.card,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.circle_outlined,
                           color: AppColor.circleIconProfilePhoto),

                          onPressed: () =>
                              markAsDone(taskBox: taskBox,
                                  doneBox: doneBox,
                                  index: index,
                                  taskTitle: taskTitle),

                        ),
                        title: Row(
                          children: [
                            Text(taskTitle, style: TextStyle(
                                fontSize: 18, color: AppColor.tasksActive)),
                            Transform.translate(offset: Offset(0, 10),
                            child: Transform.translate(offset: Offset(10 , 0),
                              child: Row(
                                children: [
                                  Text("$timeNow",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey ,
                                        fontSize: 10),
                                  ),
                                  Text(":$minuteNow \t | ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey ,
                                        fontSize: 10),
                                  ),
                                  Text("$dayNow/",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey ,
                                        fontSize: 10),
                                  ),
                                  Text("$monthNow/",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey ,
                                        fontSize: 10),
                                  ),
                                  Text("$yearsNow",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey ,
                                        fontSize: 10),
                                  ),

                                ],
                              )
                                ),)
                          ],
                        ),

                        trailing: IconButton(
                          icon: Icon(
                              Icons.delete_outline, color: AppColor.delete),
                          onPressed: () => box.deleteAt(index),

                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 25),
              ],

              ValueListenableBuilder(
                valueListenable: doneBox.listenable(),
                builder: (context, Box dBox, child) {
                  if (dBox.isEmpty) return SizedBox();
                  return DoneSection(dBox);
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.bg_add,
        onPressed: _showAddTaskSheet,
        child: Icon(Icons.add, color: AppColor.add, size: 28),
      ),
    );
  }
  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.bg_showAddTasks,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) => AnimatedPadding(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: TweenAnimationBuilder(
          duration: Duration(milliseconds: 600),
          tween: Tween<double>(
            begin: 0,
            end: 1,
          ),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(
                0,
                100 * (1 - value),
              ),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColor.container_showAddTasks,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              SizedBox(height: 25),

              TextField(
                controller: _taskController,
                style: TextStyle(color: AppColor.TextFromField),
                decoration: InputDecoration(
                  hintText: "What do you need to do?",
                  hintStyle: TextStyle(color: AppColor.hint),
                  filled: true,
                  fillColor: AppColor.bg_TextFromField,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.textFromField,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    addNewTask(
                      taskBox: taskBox,
                      context: context,
                      taskController: _taskController,
                    );
                  },
                  child: Text(
                    "Save Task",
                    style: TextStyle(
                      color: AppColor.textButton_textFromField,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}