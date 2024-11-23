import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/Courses/Faculty.dart';
import 'package:salwa_app/GraduationP/graduationProjects.dart';
import 'package:salwa_app/Setting/settings_page.dart';
import 'package:salwa_app/trainig/internship.dart';
import 'Chat/chatScreen.dart';



class Homepage extends StatefulWidget {
  final bool isGuest;
  Homepage({Key? key, this.isGuest = false}) : super(key: key); //update

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
  int index = 0;
  
  List<Widget> bottomClasses = [Homepage(), SettingsPage()];

  // Function to show dialog with scrollable content
  void showCustomDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            // Added scrollable content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWiidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: true,
            onTap: (val) {
              setState(() {
                index = val;
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => bottomClasses[index]),
                );
              });
            },
            currentIndex: index,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: 'Settings',
              ),
            ],
          ),
          appBar: AppBar(
            title: AutoSizeText(
              'Home',
              maxLines: 1,
              style: TextStyle(
                color: const Color.fromARGB(255, 8, 65, 149),
                fontSize: 40,
              ),
            ),
            actions: [
              IconButton(
                  //to log out
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                         // delete all pages and logout
                        .pushNamedAndRemoveUntil("login", (route) => false);
                  },
                  icon: const Icon(Icons.exit_to_app))
            ],
          ),
          drawer: Drawer(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 15),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/mylogo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text('AOU Library'),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ListTile(
                    title: Text('About us'),
                    leading: Icon(Icons.diversity_1),
                    onTap: () {
                      // Show About Us dialog
                      showCustomDialog(
                        'About Us',
                        'We are the AOU Library, a place where students can find resources for their studies and research. We aim to provide access to a wide range of materials and educational tools.',
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                  ListTile(
                    title: Text('Terms and Privacy'),
                    leading: Icon(Icons.privacy_tip),
                    onTap: () {
                      // Show Terms and Privacy dialog with scrollable content
                      showCustomDialog(
                        'Terms and Privacy',
                        'We prioritize your privacy and are committed to protecting your personal data. We collect basic information like your name, email, and device details to enhance app performance and improve your experience. Your data is kept secure and shared only in specific situations, such as complying with legal requirements or with trusted service providers under confidentiality agreements. You have rights to access, update, or delete your data and can withdraw consent for data usage anytime. We may update this policy and will inform you of any significant changes through the app.',
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                  ListTile(
                    title: Text('Setting'),
                    leading: Icon(Icons.settings),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                ],
              ),
            ),
          ),

          backgroundColor: Colors.grey[100], // Light background for contrast

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
                        if (widget.isGuest && titles[index] == "Chat") {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Access Restricted"),
                              content: const Text(
                                  "please log in to access the chat feature."),
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
                            MaterialPageRoute(
                                builder: (context) => classes[index]),
                          );
                        }
                      }, //update until here of preventing guest from access chat
                      child: Container(
                          width: screenWiidth,
                          margin: EdgeInsets.only(top: 10, left: 10, right: 8),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadiusDirectional.circular(20),
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
                                  color:
                                      const Color.fromARGB(255, 204, 231, 253),
                                  child: AutoSizeText(
                                    //overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    titles[index],
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                    maxLines: 1,
                                    presetFontSizes: [60, 50, 25, 19],
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
        ));
  }
}
