import 'package:flutter/material.dart';

import 'classification.dart';


class CoursePage extends StatefulWidget {
  final String courseName;

  CoursePage({required this.courseName});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        children: [
          ClassificationItem(
            title: "Lecture",
            items: ["Lecture 1", "Lecture 2", "Lecture 3"],
          ),
          ClassificationItem(
            title: "Summary",

            items: ["Summary 1", "Summary 2", "Summary 3"],
          ),
          ClassificationItem(
            title: "Old Exam",
            items: ["Exam 2022", "Exam 2021", "Exam 2020"],
          ),

        ],
      ),
    );
  }
}

