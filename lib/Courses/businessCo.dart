import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'coursepage.dart';

class Businessco extends StatefulWidget {
  const Businessco({super.key});

  @override
  State<Businessco> createState() =>_BusinesscoState ();
}

final List<String> BusinessCourses = [
"Bu310",
  "Sys280",
  "B123",
];

class _BusinesscoState extends State<Businessco> {

  @override

  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWiidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 194, 214, 231),
        title: Text(
          'Courses of Faculty of Business Studies ',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: BusinessCourses.length,
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
                    title: Text(BusinessCourses[index]),
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
                          builder: (context) => CoursePage(
                            courseName: BusinessCourses[index],
                          ),
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
