import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/Courses/businessDetails.dart'; // Ensure the import path is correct

class Businessco extends StatefulWidget {
  const Businessco({super.key});

  @override
  State<Businessco> createState() => _BusinesscoState();
}

class _BusinesscoState extends State<Businessco> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 194, 214, 231),
        title: const Text(
          'Courses of Faculty of Business Studies',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearchDialog(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc('Faculty_Of_Business')
            .collection('course_name')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No courses available."));
          }

          // Filter courses based on search query
          final courses = snapshot.data!.docs
              .where((course) =>
                  course.id.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              var courseData = courses[index];
              var courseName = courseData.id;

              return Container(
                height: screenHeight / 5,
                width: screenWidth * 0.8,
                margin: const EdgeInsets.only(top: 5),
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
                child: Center(
                  child: ListTile(
                    title: Text(courseName),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onTap: () {
                      // Navigate to the Businessdetails page with the courseName
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Businessdetails(
                              courseName:
                                  courseName), // Correctly use Businessdetails
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

  // Function to show the search dialog
  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Courses'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(hintText: "Enter course name"),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
