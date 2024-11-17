import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salwa_app/GraduationP/projectPage.dart';

class Graduationprojects extends StatefulWidget {
  const Graduationprojects({super.key});

  @override
  State<Graduationprojects> createState() => _GraduationprojectsState();
}

class _GraduationprojectsState extends State<Graduationprojects> {
  // List to store project data fetched from Firestore
  List<Map<String, dynamic>> projectData = [];

  @override
  void initState() {
    super.initState();
    fetchProjectData(); // Fetch data when the widget is initialized
  }

  // Function to fetch project data from Firestore
  Future<void> fetchProjectData() async {
    try {
      // Fetch documents from the 'graduation_projects' collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('graduation_projects')
          .get();

      // Map each document to a project data item
      setState(() {
        projectData = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id, // Document ID for navigation
            'project_name': data['project_name'] ?? 'N/A', // Project name
            'student_name': data['student_name'] ?? 'N/A', // Student(s)
            'image_url': data['image_url'] ?? '', // Image URL
            'description': data['description'] ?? 'No description available.', // Description
            'programming_language':
                data['programming_language'] ?? 'Not specified', // Language used
            'project_type': data['project_type'] ?? 'Unknown Type', // Project type
          };
        }).toList();
      });
    } catch (e) {
      print("Failed to fetch project data: $e"); // Error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graduation Projects'), // Page title
      ),
      body: projectData.isEmpty
          ? const Center(
              child: CircularProgressIndicator(), // Show loading spinner
            )
          : ListView.separated(
              itemCount: projectData.length,
              itemBuilder: (context, index) {
                final project = projectData[index];

                return InkWell(
                  onTap: () {
                    // Navigate to the project details page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Projectpage(
                          projectId: project['id'], // Pass project ID
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 3),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          // Display project name and student name in the list item
                          title: Text(project['project_name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("By: ${project['student_name']}"),
                              Text("Type: ${project['project_type']}"),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                            ),
                            width: 57,
                            height: 57,
                            // Display project image from URL
                            child: Image.network(
                              project['image_url'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              // Add space between items in the list
              separatorBuilder: (context, i) => const Divider(
                color: Colors.white,
                height: 4,
              ),
            ),
    );
  }
}