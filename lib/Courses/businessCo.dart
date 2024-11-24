import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for real-time database integration.
import 'package:flutter/material.dart'; // Import Flutter's material design package for UI elements.
import 'package:salwa_app/Courses/businessDetails.dart'; // Import the Businessdetails screen. Ensure the file path is correct.

class Businessco extends StatefulWidget { // Define a stateful widget for the Business Courses screen.
  const Businessco({super.key}); // Constructor with an optional key parameter for widget identification.

  @override
  State<Businessco> createState() => _BusinesscoState(); // Create the state object for this widget.
}

class _BusinesscoState extends State<Businessco> {
  TextEditingController _searchController = TextEditingController(); // Controller to capture and manage the text input in the search bar.
  String _searchQuery = ""; // Variable to store the user's search query.

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height; // Get the height of the screen for responsive UI design.
    var screenWidth = MediaQuery.of(context).size.width; // Get the width of the screen for responsive UI design.

    return Scaffold( // Scaffold widget to create the basic layout of the screen.
      appBar: AppBar( // AppBar widget to display a top navigation bar.
        backgroundColor: const Color.fromARGB(255, 194, 214, 231), // Set the background color of the AppBar.
        title: const Text(
          'Courses of Faculty of Business Studies', // Title text displayed in the AppBar.
          style: TextStyle(color: Colors.white, fontSize: 20), // Set the style of the AppBar title.
        ),
        actions: [ // Define actions (buttons) in the AppBar.
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white), // Search icon in the AppBar.
            onPressed: () { // Define the behavior when the search icon is tapped.
              showSearchDialog(context); // Call the method to display the search dialog.
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>( // StreamBuilder widget to handle real-time data from Firestore.
        stream: FirebaseFirestore.instance // Access Firestore's instance.
            .collection('courses') // Target the 'courses' collection in Firestore.
            .doc('Faculty_Of_Business') // Access the specific document for the Faculty of Business.
            .collection('course_name') // Access the sub-collection containing the course names.
            .snapshots(), // Listen to real-time updates from Firestore.
        builder: (context, snapshot) { // Builder function to update the UI based on Firestore data.
          if (snapshot.connectionState == ConnectionState.waiting) { // Check if the connection is still loading.
            return const Center(child: CircularProgressIndicator()); // Show a loading spinner while waiting for data.
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) { // Check if no data is retrieved or the list is empty.
            return const Center(child: Text("No courses available.")); // Display a message if no courses are found.
          }

          // Filter the list of courses based on the user's search query.
          final courses = snapshot.data!.docs
              .where((course) =>
              course.id.toLowerCase().contains(_searchQuery.toLowerCase())) // Match course IDs with the search query (case-insensitive).
              .toList();

          return ListView.builder( // Use ListView.builder to dynamically build a list of courses.
            itemCount: courses.length, // Define the number of list items based on the filtered courses.
            itemBuilder: (context, index) { // Build each item in the list.
              var courseData = courses[index]; // Get the course data for the current index.
              var courseName = courseData.id; // Get the course name (assumed to be the document ID).

              return Container( // Container to display each course as a card-like item.
                height: screenHeight / 5, // Set the height of the container proportionally to the screen size.
                width: screenWidth * 0.8, // Set the width of the container proportionally to the screen size.
                margin: const EdgeInsets.only(top: 5), // Add a top margin for spacing between items.
                decoration: BoxDecoration( // Define the appearance of the container.
                  border: Border.all(color: Colors.black26, width: 3), // Add a border around the container.
                  color: Colors.white, // Set the background color of the container.
                  boxShadow: [ // Add a shadow for a subtle 3D effect.
                    BoxShadow(
                      color: Colors.black26, // Set the shadow color.
                      spreadRadius: 1, // Set how far the shadow spreads.
                      blurRadius: 6, // Set the blur effect of the shadow.
                    ),
                  ],
                ),
                child: Center( // Center-align the content inside the container.
                  child: ListTile( // Use ListTile widget to represent each course.
                    title: Text(courseName), // Display the course name as the title of the ListTile.
                    trailing: const Icon( // Add a trailing icon (arrow) to the ListTile.
                      Icons.arrow_forward_ios, // Use the forward arrow icon.
                      color: Colors.blue, // Set the color of the icon.
                      size: 30, // Define the size of the icon.
                    ),
                    onTap: () { // Define what happens when the ListTile is tapped.
                      Navigator.push( // Navigate to the Businessdetails screen.
                        context,
                        MaterialPageRoute(
                          builder: (context) => Businessdetails(
                              courseName: courseName), // Pass the courseName as a parameter to the Businessdetails screen.
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Function to display the search dialog box.
  void showSearchDialog(BuildContext context) {
    showDialog( // Show a dialog box.
      context: context,
      builder: (context) => AlertDialog( // Define the appearance and behavior of the dialog box.
        title: const Text('Search Courses'), // Title displayed in the dialog box.
        content: TextField( // TextField widget to accept user input for the search.
          controller: _searchController, // Attach the TextEditingController to the TextField.
          decoration: const InputDecoration(hintText: "Enter course name"), // Placeholder text for the search input.
          onChanged: (value) { // Define behavior when the text input changes.
            setState(() { // Update the state of the widget.
              _searchQuery = value; // Update the search query with the user's input.
            });
          },
        ),
        actions: [ // Define the actions available in the dialog box.
          TextButton(
            onPressed: () { // Define behavior for the close button.
              Navigator.of(context).pop(); // Close the dialog box.
            },
            child: const Text("Close"), // Label for the close button.
          ),
        ],
      ),
    );
  }
}
