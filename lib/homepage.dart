import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/Courses/Faculty.dart';
import 'package:salwa_app/GraduationP/graduationProjects.dart';
import 'package:salwa_app/Setting/settings_page.dart';
import 'package:salwa_app/auth/login.dart';
import 'package:salwa_app/trainig/internship.dart';
import 'Chat/chatScreen.dart';

// HomePage widget, defining the main structure of the app's home page.
class Homepage extends StatefulWidget {
  final bool isGuest; // Flag to indicate if the user is a guest.
  Homepage({Key? key, this.isGuest = false})
      : super(key: key); // Constructor to initialize the isGuest flag.

  @override
  State<Homepage> createState() =>
      _HomepageState(); // Links the state to the widget.
}

// State class for Homepage.
class _HomepageState extends State<Homepage> {
  List img = [
    "assets/courses.png",
    "assets/graduation project.png",
    "assets/internship.png",
    "assets/chat.png"
  ];
  List titles = [
    "Courses",
    "Graduation Projects",
    "Internship",
    "Chat"
  ]; // List of titles for grid items.
  List<Widget> classes = [
    Faculty(),
    Graduationprojects(),
    Internship(),
    ChatScreen(),
  ]; // List of pages to navigate to when a grid item is clicked.
  int index = 0; // Current index for the BottomNavigationBar.

  List<Widget> bottomClasses = [
    Homepage(),
    SettingsPage()
  ]; // List of pages for the BottomNavigationBar.

  // Function to show dialog with scrollable content
  void showCustomDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            // Ensures content is scrollable if long.
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
                Navigator.of(context).pop(); // Closes the dialog.
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
    var screenHeight = MediaQuery.of(context).size.height; //screen hieght
    var screenWiidth = MediaQuery.of(context).size.width; // screen width
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        // Bottom navigation bar.
        showSelectedLabels: true, // Shows labels for selected items.
        onTap: (val) {
          setState(() {
            index = val; // Updates the index.
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => bottomClasses[index]),
            );
          });
        },
        currentIndex: index, // Current selected index.
        items: <BottomNavigationBarItem>[
          // Navigation items.
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
        // Top app bar.
        title: AutoSizeText(
          // Resizable text.
          'Home',
          presetFontSizes: [screenWiidth >= 700 ? 40 : 25],

          style: TextStyle(
            color: const Color.fromARGB(255, 8, 65, 149),
          ),
        ),
        actions: [
          IconButton(
            //to log out
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Logs the user out.
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Login())); // Redirects to login.
            },
            icon: const Icon(Icons.exit_to_app),
            iconSize: screenWiidth >= 700 ? 40 : 25,
          )
        ],
      ),
      drawer: Drawer(
        // Side navigation drawer.
        child: Container(
          width: screenWiidth >= 700 ? 30 : 20,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 15),
          child: ListView(
            children: [
              Row(
                // Header of the drawer.
                children: [
                  Container(
                    width: screenWiidth >= 700 ? 120 : 60,
                    height: screenWiidth >= 700 ? 120 : 60,
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
                      title: AutoSizeText(
                        'AOU Library',
                        presetFontSizes: [
                          screenWiidth >= 700 ? 35 : 25,
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              ListTile(
                title: AutoSizeText(
                  'About us',
                  presetFontSizes: [
                    screenWiidth >= 700 ? 30 : 20,
                  ],
                ),
                leading: Icon(
                  Icons.diversity_1,
                  size: screenWiidth >= 700 ? 30 : 20,
                ),
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
                title: AutoSizeText(
                  'Terms and Privacy',
                  presetFontSizes: [screenWiidth >= 700 ? 30 : 20],
                ),
                leading: Icon(
                  Icons.privacy_tip,
                  size: screenWiidth >= 700 ? 30 : 20,
                ),
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
              // Settings menu item.
              ListTile(
                title: AutoSizeText(
                  'Setting',
                  presetFontSizes: [screenWiidth >= 700 ? 30 : 20],
                ),
                leading: Icon(
                  Icons.settings,
                  size: screenWiidth >= 700 ? 30 : 20,
                ),
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
        // Main body containing a grid view.
        child: Container(
          height: screenHeight,
          width: screenWiidth,
          padding: EdgeInsets.symmetric(vertical: 15),
          child: GridView.builder(
              // Dynamically creates the grid.
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of items per row.
                mainAxisSpacing: 25, // Vertical spacing.
                childAspectRatio: 1, // Aspect ratio of grid items.
              ),
              itemCount: img.length, // Number of grid items.
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Prevents scrolling.
              itemBuilder: (
                context,
                index,
              ) {
                return InkWell(
                  // Wraps the item for tap detection.
                  onTap: () {
                    if (widget.isGuest && titles[index] == "Chat") {
                      // Prevents guest access to chat.
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
                        MaterialPageRoute(builder: (context) => classes[index]),
                      );
                    }
                  }, //update until here of preventing guest from access chat
                  child: Container(
                      // Grid item container.
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
                          // Contents of each grid item.
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              // Image in the grid item.
                              padding: EdgeInsets.all(8),
                              width: localWidth,
                              height: localHeight * 0.75,
                              child: Image.asset(
                                img[index],
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              // Title under the image.
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
    );
  }
}
