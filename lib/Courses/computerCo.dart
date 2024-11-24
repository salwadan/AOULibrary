import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package for accessing the database.
import 'package:flutter/material.dart'; // Import Flutter material design package for UI components.
import 'computerDetails.dart'; // Import the details page for computer courses.

class Computerco extends StatefulWidget { // Define a stateful widget for displaying computer courses.
  const Computerco({super.key}); // Constructor with a key for widget identification.

  @override
  State<Computerco> createState() => _ComputercoState(); // Create and return the widget's state.
}

class _ComputercoState extends State<Computerco> {
  TextEditingController _searchController = TextEditingController(); // Controller for managing search input.
  String _searchQuery = ""; // Variable to store the current search query.

  @override
  Widget build(BuildContext context) { // Build method to construct the UI.
    var screenHeight = MediaQuery.of(context).size.height; // Get the screen height.
    var screenWidth = MediaQuery.of(context).size.width; // Get the screen width.

    return Scaffold(
      appBar: AppBar( // AppBar widget for the top navigation bar.
        backgroundColor: const Color.fromARGB(255, 194, 214, 231), // Set background color of the AppBar.
        title: const Text( // Title of the AppBar.
          'Courses of Faculty of Computer Studies',
          style: TextStyle(color: Colors.white, fontSize: 20), // Styling for the title text.
        ),
        actions: [
          IconButton( // Add a search icon button in the AppBar.
            icon: const Icon(Icons.search, color: Colors.white), // Search icon.
            onPressed: () {
              showSearchDialog(context); // Open the search dialog when the icon is pressed.
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>( // Use StreamBuilder to listen to real-time data changes in Firestore.
        stream: FirebaseFirestore.instance // Access Firestore database.
            .collection('courses') // Access the 'courses' collection.
            .doc('Faculty_Of_Computer') // Access the document for the computer faculty.
            .collection('course_name') // Access the sub-collection with course names.
            .snapshots(), // Get a real-time stream of the data.
        builder: (context, snapshot) { // Builder function to create UI based on snapshot data.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show a loading spinner while waiting for data.
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No courses available.")); // Show a message if no courses are found.
          }

          final courses = snapshot.data!.docs // Filter the courses based on the search query.
              .where((course) =>
              course.id.toLowerCase().contains(_searchQuery.toLowerCase())) // Check if the course name matches the query.
              .toList();

          return ListView.builder( // Create a list view to display the courses.
            itemCount: courses.length, // Number of courses to display.
            itemBuilder: (context, index) {
              var courseData = courses[index]; // Get the current course data.
              var courseName = courseData.id; // Use the document ID as the course name.

              return Container( // Container for styling each course item.
                height: screenHeight / 5, // Set the height relative to the screen size.
                width: screenWidth * 0.8, // Set the width relative to the screen size.
                margin: const EdgeInsets.only(top: 5), // Add a margin at the top.
                decoration: BoxDecoration( // Apply styling to the container.
                  border: Border.all(color: Colors.black26, width: 3), // Add a border around the container.
                  color: Colors.white, // Set the background color.
                  boxShadow: [ // Add a shadow for a 3D effect.
                    BoxShadow(
                      color: Colors.black26, // Shadow color.
                      spreadRadius: 1, // How far the shadow spreads.
                      blurRadius: 6, // Blur effect for the shadow.
                    ),
                  ],
                ),
                child: Center(
                  child: ListTile( // Use ListTile to display the course name and an icon.
                    title: Text(courseName), // Display the course name.
                    trailing: const Icon( // Add an arrow icon for navigation.
                      Icons.arrow_forward_ios,
                      color: Colors.blue, // Set the icon color.
                      size: 30, // Set the icon size.
                    ),
                    onTap: () { // Action when the course item is tapped.
                      Navigator.push( // Navigate to the course details page.
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CoursePage(courseName: courseName), // Pass the course name to the details page.
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

  void showSearchDialog(BuildContext context) { // Function to display a search dialog.
    showDialog(
      context: context, // Context for the dialog.
      builder: (context) => AlertDialog(
        title: const Text('Search Courses'), // Title of the dialog.
        content: TextField( // TextField for user input.
          controller: _searchController, // Connect the TextField to the controller.
          decoration: const InputDecoration(hintText: "Enter course name"), // Placeholder text.
          onChanged: (value) { // Update the search query whenever the input changes.
            setState(() {
              _searchQuery = value; // Set the search query state.
            });
          },
        ),
        actions: [
          TextButton( // Close button for the dialog.
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog.
            },
            child: const Text("Close"), // Button label.
          ),
        ],
      ),
    );
  }
}
