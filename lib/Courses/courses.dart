import 'package:flutter/material.dart';
import 'package:salwa_app/Courses/computerDetails.dart'; // Ensure this is your course page file
import 'comments.dart'; // Feedback section

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Courses',
            style: TextStyle(color: Colors.blue),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Material',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Tab(
                child: Text(
                  'Feedback',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: TabBarView(
            children: [
              // Pass the course name dynamically to the CoursePage
              CoursePage(
                courseName:
                    "courseName", // Replace with dynamic course name if needed
              ),

              // Pass the courseId (courseName) to Comments widget
              Comments(
                  courseId:
                      "courseName"), // Use courseName as courseId or replace with the correct identifier
            ],
          ),
        ),
      ),
    );
  }
}
