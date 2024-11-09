import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/Courses/LanguageCo.dart';
import 'package:salwa_app/Courses/businessCo.dart';
import 'package:salwa_app/Courses/computerCo.dart';

class Faculty extends StatefulWidget {
  const Faculty({super.key});

  @override
  State<Faculty> createState() => _FacultyState();
}

final List<Widget> classes = [
  Computerco(),
  Businessco(),
  LanguageCo(),
];

final List<String> faculty = [
  "Faculty of computer studies ",
  " Faculty of Business Studies",
  " Faculty of Language Studies"
];
List images = [
  "assets/computerFaculty.png",
  "assets/Buisness.png",
  "assets/languages.png"
];

class _FacultyState extends State<Faculty> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWiidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 194, 214, 231),
          title: Text(
            'University majors ',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        body: ListView.builder(
            itemCount: faculty.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => classes[index]));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  height: screenHeight / 3,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        offset: Offset(
                          0.0,
                          10.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: -6.0,
                      ),
                    ],
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.35),
                        BlendMode.multiply,
                      ),
                      image: AssetImage(images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 97, 95, 95)
                                  .withOpacity(0.4),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              title: AutoSizeText(
                                faculty[index],
                                maxLines: 1,
                                presetFontSizes: [50, 40, 30, 25, 20],
                                wrapWords: false,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_outlined,
                                color: Colors.blue,
                                size: 25,
                              ),
                            )),
                      ),
                    ],
                  ),
                  alignment: Alignment.bottomLeft,
                ),
              );
            }));
  }
}
