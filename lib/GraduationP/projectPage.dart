import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Projectpage extends StatefulWidget {
  final String projectId; // Pass the project ID to display its details

  const Projectpage({Key? key, required this.projectId}) : super(key: key);

  @override
  State<Projectpage> createState() => _ProjectpageState();
}

class _ProjectpageState extends State<Projectpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Details"), // Title of the app bar
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the content
          child: FutureBuilder<DocumentSnapshot>(
            // Fetching specific project data using the provided projectId
            future: FirebaseFirestore.instance
                .collection('graduation_projects')
                .doc(widget.projectId)
                .get(),
            builder: (context, snapshot) {
              // Display a loading indicator while data is being fetched
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Handle case where data is not found or an error occurs
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(
                  child: Text("Project not found or unavailable."),
                );
              }

              // Extract the project data
              var project = snapshot.data!.data() as Map<String, dynamic>;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row for the image and basic project details
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150, // Image container height
                          width: 150, // Image container width
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade200, // Shadow color
                                spreadRadius: 2, // Spread radius
                                blurRadius: 6, // Blur radius
                              ),
                            ],
                          ),
                          // Display the project image from Firebase URL
                          child: Image.network(
                            project['image_url'] ?? '', // Default empty if null
                            fit: BoxFit.cover, // Ensure image fills container
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                size: 150,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 30), // Space between image and text
                        // Column for the project name and student name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project['project_name'] ?? 'N/A', // Project name
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "By: ${project['student_name'] ?? 'N/A'}", // Student name
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Type: ${project['project_type'] ?? 'Unknown Type'}", // Project type
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32), // Space between sections

                    // "About" Section Title
                    const Text(
                      "About",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8), // Space between title and content
                    Text(
                      project['description'] ?? 'No description available.',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20), // Space between sections

                    // "Programming Language" Section
                    const Text(
                      "Programming Language",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project['programming_language'] ??
                          'No language specified.', // Programming language
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
