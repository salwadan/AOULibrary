import 'package:auto_size_text/auto_size_text.dart'; // For dynamically resizing text.
import 'package:flutter/material.dart'; // Import Flutter material design package.
import 'package:salwa_app/Courses/LanguageCo.dart'; // Import the LanguageCo screen.
import 'package:salwa_app/Courses/businessCo.dart'; // Import the BusinessCo screen.
import 'package:salwa_app/Courses/computerCo.dart'; // Import the ComputerCo screen.

// Main widget for Faculty
class Faculty extends StatefulWidget {
  const Faculty({super.key}); // Constructor with a key for widget identification.

  @override
  State<Faculty> createState() => _FacultyState(); // Create the state for this widget.
}

// List of widgets for different faculties.
final List<Widget> classes = [
  Computerco(), // Computer faculty screen.
  Businessco(), // Business faculty screen.
  LanguageCo(), // Language faculty screen.
];

// List of faculty names.
final List<String> faculty = [
  "Faculty of Computer Studies",
  "Faculty of Business Studies",
  "Faculty of Language Studies"
];

// List of image assets corresponding to each faculty.
List images = [
  "assets/computerFaculty.png", // Computer faculty image.
  "assets/Buisness.png", // Business faculty image.
  "assets/language.jpeg" // Language faculty image.
];

// State class for Faculty widget.
class _FacultyState extends State<Faculty> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height; // Get screen height.
    var screenWiidth = MediaQuery.of(context).size.width; // Get screen width.
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(194, 214, 231, 1), // Light blue background.
          title: Text(
            'University Faculty', // Title of the page.
          ),
        ),
        body: ListView.builder(
          // Dynamically build a list of faculty items.
            itemCount: faculty.length, // Number of items equals the faculty list length.
            itemBuilder: (context, index) {
              return InkWell(
                // Makes the entire item tappable.
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => classes[index])); // Navigate to the corresponding faculty screen.
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10), // Spacing around the item.
                  width: MediaQuery.of(context).size.width, // Full screen width.
                  height: screenHeight / 3, // One-third of the screen height.
                  decoration: BoxDecoration(
                    color: Colors.black, // Background color.
                    borderRadius: BorderRadius.circular(15), // Rounded corners.
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6), // Shadow color with opacity.
                        offset: Offset(
                          0.0, // Horizontal offset of shadow.
                          10.0, // Vertical offset of shadow.
                        ),
                        blurRadius: 10.0, // Blur effect of the shadow.
                        spreadRadius: -6.0, // Spread of the shadow.
                      ),
                    ],
                    image: DecorationImage(
                      // Overlay image for the faculty item.
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.35), // Darken the image with an overlay.
                        BlendMode.multiply,
                      ),
                      image: AssetImage(images[index]), // Use corresponding image from the list.
                      fit: BoxFit.cover, // Cover the container area.
                    ),
                  ),
                  child: Stack(
                    // Stack for positioning elements on top of the image.
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter, // Position content at the bottom center.
                        child: Container(
                            padding: EdgeInsets.all(5), // Padding inside the container.
                            margin: EdgeInsets.all(10), // Margin outside the container.
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 97, 95, 95)
                                  .withOpacity(0.4), // Semi-transparent background.
                              borderRadius: BorderRadius.circular(15), // Rounded corners.
                            ),
                            child: ListTile(
                              title: AutoSizeText(
                                // Automatically adjust the text size.
                                faculty[index], // Display the faculty name.
                                maxLines: 1, // Limit to one line.
                                presetFontSizes: [50, 40, 30, 25, 20], // Text size levels.
                                wrapWords: false, // Prevent word wrapping.
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, // Bold text.
                                    color: Colors.white), // White text color.
                              ),
                              trailing: Icon(
                                // Arrow icon at the end of the ListTile.
                                Icons.arrow_forward_outlined, // Forward arrow icon.
                                color: Colors.blue, // Icon color.
                                size: 25, // Icon size.
                              ),
                            )),
                      ),
                    ],
                  ),
                  alignment: Alignment.bottomLeft, // Align the stack at the bottom left.
                ),
              );
            }));
  }
}

