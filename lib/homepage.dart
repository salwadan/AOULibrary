import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/Courses/Faculty.dart';
import 'package:salwa_app/GraduationP/graduationProjects.dart';
import 'package:salwa_app/GraduationP/projectPage.dart';
import 'package:salwa_app/trainig/internship.dart';
import 'chatScreen.dart';

class Homepage extends StatefulWidget {
  final bool isGuest;
  Homepage({Key? key, this.isGuest = false}) : super(key: key);

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
    Faculty(),
    Graduationprojects(),
    Internship(),
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for contrast
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          padding: EdgeInsets.symmetric(vertical: 15),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              childAspectRatio: 1, // Ensures each grid item is square
            ),
            itemCount: img.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (widget.isGuest && titles[index] == "Chat") {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Access Restricted"),
                        content: const Text(
                            "Please log in to access the chat feature."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => classes[index]),
                    );
                  }
                },
                child: Container(
                  width: screenWidth,
                  margin: EdgeInsets.only(top: 10, left: 10, right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 1,
                        blurRadius: 6,
                      )
                    ],
                  ),
                  child: LayoutBuilder(builder: (context, constraints) {
                    double localHeight = constraints.maxHeight;
                    double localWidth = constraints.maxWidth;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          width: localWidth,
                          height: localHeight * 0.75,
                          child: Image.asset(
                            img[index],
                            fit: BoxFit
                                .cover, // Ensures the image maintains aspect ratio and is cropped if needed
                          ),
                        ),
                        Container(
                          width: localWidth,
                          height: localHeight * 0.25,
                          alignment: Alignment.center,
                          color: const Color.fromARGB(255, 204, 231, 253),
                          child: AutoSizeText(
                            titles[index],
                            style: TextStyle(
                              fontSize: 20, // Base font size
                              fontWeight:
                                  FontWeight.w500, // Optional for emphasis
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            minFontSize: 14, // Minimum font size
                            presetFontSizes: [
                              20,
                              18,
                              16,
                              14
                            ], // Font size priority
                            wrapWords: false,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
