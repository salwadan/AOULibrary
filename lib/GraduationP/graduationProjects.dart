import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salwa_app/GraduationP/pageOfProject.dart';

class Graduationprojects extends StatefulWidget {
  const Graduationprojects({super.key});

  @override
  State<Graduationprojects> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Graduationprojects> {
  // List to store project data fetched from Firestore
  List projectData = [];

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

      List<QueryDocumentSnapshot> docs = snapshot.docs;

      // Map each document to a project data item
      setState(() {
        projectData = docs
            .map((doc) => {
                  'project_name': doc['project_name'], // Project name
                  'student_name': doc['student_name'], // Student(s) involved
                  'image_url': doc['image_url'], // Image URL
                  'description': doc['description'], // Project description
                  'programming_language':
                      doc['programming_language'], // Language used
                })
            .toList();
      });
    } catch (e) {
      print("Failed to fetch project data: $e"); // Error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graduation Projects'), // Page title
      ),
      body: projectData.isEmpty
          ? const Center(
              child: CircularProgressIndicator(), // Show loading spinner
            )
          : ListView.separated(
              itemCount: projectData.length,
              itemBuilder: (context, index) {
                // InkWell to detect taps on the project item
                return InkWell(
                  onTap: () {
                    // Navigate to the project details page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Pageofproject(
                          projectName: projectData[index]['project_name'],
                          studentName: projectData[index]['student_name'],
                          description: projectData[index]['description'],
                          imageUrl: projectData[index]['image_url'],
                          programmingLanguage: projectData[index]
                              ['programming_language'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 3),
                      color: Colors.white,
                      boxShadow: [
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
                          title: Text(projectData[index]['project_name']),
                          subtitle: Text(projectData[index]['student_name']),
                          trailing: Icon(Icons.arrow_forward_ios),
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                            ),
                            width: 57,
                            height: 57,
                            // Display project image from URL
                            child: Image.network(
                              projectData[index]['image_url'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              // Add space between items in the list
              separatorBuilder: (context, i) => Divider(
                color: Colors.white,
                height: 4,
              ),
            ),
    );
  }
}
