import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/Courses/coursepage.dart';
import 'package:salwa_app/trainig/internship.dart';
import 'GraduationP/graduationProjects.dart';
import 'chatScreen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List img = [
    "assets/courses.png",
    "assets/graduation project.png",
    "assets/internship.png",
    "assets/chat.png"
  ];
  List titles = ["Courses", "Graduation Projects", "Internship", "Chat"];
  List<Widget> classes = [
    Courses(),
    Graduationprojects(),
    Internship(),
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWiidth = MediaQuery.of(context).size.width;
    return Scaffold(
   
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: screenWiidth,
          padding: EdgeInsets.symmetric(vertical: 15),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 25,
                childAspectRatio: 1,
              ),
              itemCount: img.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (
                context,
                index,
              ) {
                return InkWell(
                  onTap: () {
                  
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>  classes[index]));
                  },
                  child: Container(
                      width: screenWiidth,
                      margin: EdgeInsets.only(top: 10, left: 10, right: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1,
                              blurRadius: 6,
                            )
                          ]),
                      child: LayoutBuilder(builder: (context, constrains) {
                        double localHeight = constrains.maxHeight;
                        double localWidth = constrains.maxWidth;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              width: localWidth,
                              height: localHeight * 0.75,
                              child: Image.asset(
                                img[index],
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              width: localWidth,
                              height: localHeight * 0.25,
                              alignment: Alignment.center,
                              color: const Color.fromARGB(255, 204, 231, 253),
                              child: AutoSizeText(
                                //overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                titles[index],
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                                maxLines: 1,
                               presetFontSizes: [60,50, 25, 19],
                               wrapWords: false,
                              ),
                            ),
                          ],
                        );
                      })),
                );
              }),
        ),
      ),
    );
  }
}
