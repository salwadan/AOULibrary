import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'coursepage.dart';

class LanguageCo extends StatefulWidget {
  const LanguageCo({super.key});

  @override
  State<LanguageCo> createState() =>_LanguageCoState ();
}

final List<String> LanguageCourses = [
  'EL118',
  'EL122',
  'EL120',
  'EL112',
];

class _LanguageCoState extends State<LanguageCo> {

  @override

  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWiidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 194, 214, 231),
        title: Text(
          'Courses of Faculty of Language Studies  ',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: LanguageCourses.length,
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
                    title: Text(LanguageCourses[index]),
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
                            courseName: LanguageCourses[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),),



    );
  }
}
