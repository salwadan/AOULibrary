import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/Courses/languageDetails.dart'; // Correct import for Language details page

class LanguageCo extends StatefulWidget {
  const LanguageCo({super.key});

  @override
  State<LanguageCo> createState() => _LanguageCoState();
}

class _LanguageCoState extends State<LanguageCo> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 194, 214, 231),
        title: const Text(
          'Courses of Faculty of Language Studies',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(
                'Faculty_Of_Language') // Ensure this is the correct collection for Language Faculty
            .collection('course_name')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No courses available."));
          }

          final courses = snapshot.data!.docs;

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              var courseData = courses[index];
              var courseName =
                  courseData.id; // Get course name from document ID

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
                      // Navigate to the Languagedetails page with the courseName
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Languagedetails(courseName: courseName),
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
}
