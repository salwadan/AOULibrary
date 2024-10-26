import 'package:flutter/material.dart';

class Pageofproject extends StatefulWidget {
  final String projectName; // To hold the project name
  final String studentName; // To hold the student's name
  final String description; // To hold the project description
  final String imageUrl; // To hold the image URL
  final String programmingLanguage; // To hold the programming language used
  final String studentEmail; // To hold student's email (if necessary)

  const Pageofproject({
    super.key,
    required this.projectName,
    required this.studentName,
    required this.description,
    required this.imageUrl,
    required this.programmingLanguage,
    required this.studentEmail,
  });

  @override
  State<Pageofproject> createState() => _PageofprojectState();
}

class _PageofprojectState extends State<Pageofproject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectName), // Set app bar title to project name
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.all(16.0), // Add padding around the content
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align content to start
              children: [
                Container(
                  height: 200, // Increased height for better visibility
                  width: double.infinity, // Full width of the screen
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    image: DecorationImage(
                      image: NetworkImage(widget.imageUrl), // Display project image
                      fit: BoxFit.cover, // Cover the entire container
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Space between elements
                Text(
                  "Project Name: ${widget.projectName}", // Display project name
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Student Name: ${widget.studentName}", // Display student name
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Programming Language: ${widget.programmingLanguage}", // Display programming language
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Description: ${widget.description}", // Display project description
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Contact Email: ${widget.studentEmail}", // Display student email
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
