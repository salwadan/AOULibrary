import 'package:cloud_firestore/cloud_firestore.dart'; // For Firebase Firestore integration.
import 'package:flutter/material.dart'; // Flutter material design package.
import 'package:salwa_app/Courses/languageDetails.dart'; // Import the Language details page.

class LanguageCo extends StatefulWidget {
  const LanguageCo({super.key}); // Constructor with a key for widget identification.

  @override
  State<LanguageCo> createState() => _LanguageCoState(); // Create the state for this widget.
}

class _LanguageCoState extends State<LanguageCo> {
  TextEditingController _searchController = TextEditingController(); // Controller for the search input field.
  String _searchQuery = ""; // Stores the current search query.

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height; // Get screen height.
    var screenWidth = MediaQuery.of(context).size.width; // Get screen width.

    return Scaffold(
      appBar: AppBar(
        // AppBar with a title and search action.
        backgroundColor: const Color.fromARGB(255, 194, 214, 231), // Light blue color.
        title: const Text(
          'Courses of Faculty of Language Studies', // Title of the page.
          style: TextStyle(color: Colors.white, fontSize: 20), // White text with font size 20.
        ),
        actions: [
          IconButton(
            // Search button in the AppBar.
            icon: const Icon(Icons.search, color: Colors.white), // Search icon.
            onPressed: () {
              showSearchDialog(context); // Show the search dialog when pressed.
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // StreamBuilder to fetch and display real-time data from Firestore.
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc('Faculty_Of_Language') // Document for Language Faculty courses.
            .collection('course_name') // Subcollection containing course names.
            .snapshots(), // Listen for real-time updates.
        builder: (context, snapshot) {
          // Handle the different states of the snapshot.
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while data is being fetched.
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Show a message if no data is available.
            return const Center(child: Text("No courses available."));
          }

          // Filter courses based on the search query.
          final courses = snapshot.data!.docs
              .where((course) =>
              course.id.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

          // Build a list of filtered courses.
          return ListView.builder(
            itemCount: courses.length, // Number of courses to display.
            itemBuilder: (context, index) {
              var courseData = courses[index]; // Get course data at the current index.
              var courseName = courseData.id; // Course name.

              return Container(
                // Container to display each course item.
                height: screenHeight / 5, // Set container height.
                width: screenWidth * 0.8, // Set container width.
                margin: const EdgeInsets.only(top: 5), // Top margin for spacing.
                decoration: BoxDecoration(
                  // Add border and shadow for styling.
                  border: Border.all(color: Colors.black26, width: 3), // Border color and width.
                  color: Colors.white, // Background color.
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // Shadow color.
                      spreadRadius: 1, // Spread radius of the shadow.
                      blurRadius: 6, // Blur radius of the shadow.
                    ),
                  ],
                ),
                child: Center(
                  // Center-align the ListTile.
                  child: ListTile(
                    title: Text(courseName), // Display the course name.
                    trailing: const Icon(
                      // Arrow icon on the right.
                      Icons.arrow_forward_ios,
                      color: Colors.blue, // Blue icon color.
                      size: 30, // Icon size.
                    ),
                    onTap: () {
                      // Navigate to the details page for the selected course.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Languagedetails(courseName: courseName), // Pass the course name to details page.
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

  // Function to show the search dialog.
  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Dialog for search functionality.
        title: const Text('Search Courses'), // Dialog title.
        content: TextField(
          // Input field for search query.
          controller: _searchController, // Bind to the search controller.
          decoration: const InputDecoration(hintText: "Enter course name"), // Hint text.
          onChanged: (value) {
            // Update the search query in real-time.
            setState(() {
              _searchQuery = value; // Update search query state.
            });
          },
        ),
        actions: [
          TextButton(
            // Close button for the dialog.
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog.
            },
            child: const Text("Close"), // Button text.
          ),
        ],
      ),
    );
  }
}

