import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Projectpage extends StatefulWidget {
  const Projectpage({super.key});

  @override
  State<Projectpage> createState() => _ProjectpageState();
}

class _ProjectpageState extends State<Projectpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Project Name"), // Title of the app bar
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the content
          child: StreamBuilder(
            // Fetching data from the Firebase Firestore collection 'graduation_projects'
            stream: FirebaseFirestore.instance
                .collection('graduation_projects')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // Display a loading indicator while data is being fetched
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              // Display a message if no data is found
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No projects available"));
              }

              // Assuming that we want to display the first project document
              var project = snapshot.data!.docs[0];

              return Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align items to start
                children: [
                  // Row for the image and basic project details
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 150, // Image container height
                          width: 150, // Image container width
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue, // Shadow color
                                spreadRadius: 2, // Spread radius of the shadow
                                blurRadius: 6, // Blur radius of the shadow
                              )
                            ],
                          ),
                          // Displaying the project image from Firebase URL
                          child: Image.network(
                            project['image_url'],
                            fit: BoxFit.fill, // Ensure image fills container
                          ),
                        ),
                      ),
                      SizedBox(width: 30), // Space between image and text
                      // Column for the project name and student name
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text to start
                        children: [
                          Text(
                            project[
                                'project_name'], // Project name from Firebase
                            style: TextStyle(fontSize: 34),
                          ),
                          Text(
                            project[
                                'student_name'], // Student name from Firebase
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8), // Space between text elements
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32), // Space between sections

                  // "About" Section Title
                  Text(
                    "About",
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8), // Space between title and description

                  // Project description
                  Text(
                    project['description'], // Description from Firebase
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20), // Space between sections

                  // "Programming Language" Section
                  AutoSizeText(
                    "Programming Language",
                    presetFontSizes: [
                      30,
                      40,
                      50
                    ], // Font sizes for auto-resizing
                  ),
                  AutoSizeText(
                    project[
                        'programming_language'], // Programming language from Firebase
                    presetFontSizes: [
                      18,
                      20,
                      25
                    ], // Font sizes for auto-resizing
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
