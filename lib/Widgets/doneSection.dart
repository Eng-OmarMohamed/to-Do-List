import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../core/colors.dart';

Widget DoneSection(Box dBox) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            "Completed Tasks",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.completed,
            ),
          ),

          SizedBox(width: 8),

          Lottie.asset(
            'assets/animations/completed.json',
            width: 40,
            height: 40,
          ),
        ],
      ),
      SizedBox(height: 10),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: dBox.length,
        itemBuilder: (context, index) {
          final taskTitle = dBox.getAt(index).toString();
          return Card(
            color: Color(0xFF1A1A1A),
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: Icon(Icons.check_circle, color: AppColor.Completed),
              title: Text(
                taskTitle,
                style: TextStyle(
                    fontSize: 18,
                    color: AppColor.done,
                    decoration: TextDecoration.lineThrough),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete_outline, color: AppColor.delete),
                onPressed: () => dBox.deleteAt(index),
              ),
            ),
          );
        },
      ),
    ],
  );
}