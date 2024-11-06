import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salwa_app/Courses/courses.dart';

import 'coursepage.dart';

class Computerco extends StatefulWidget {
  const Computerco({super.key});

  @override
  State<Computerco> createState() =>_ComputercoState ();
}


final List<String> computerCourses = [
  "TM351",
  "MT101",
  "TM366",
  "TM105",
  "MT132",
  "Tu170"
];

class _ComputercoState extends State<Computerco> {

  @override

  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWiidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 194, 214, 231),
        title: Text(
          'Courses of faculty of Computer Studies  ',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: computerCourses.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index)

            {
              return Container(
                height: screenHeight / 5,
                width: screenWiidth * 0.8,
                margin: EdgeInsets.only(top: 5),

                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26, width: 3),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 1,
                        blurRadius: 6,
                      ),
                    ]),
                child: Center(
                  child: ListTile(
                    title: Text(computerCourses[index]),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onTap: () {
                      // Navigate to the CoursePage when an item is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Courses(),


                        ),
                      );
                    },
                  ),
                ),
              );
            },
          )),



    );
  }
}


