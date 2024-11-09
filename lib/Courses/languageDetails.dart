import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'comments.dart'; // Assuming you have a Comments widget for feedback

class Languagedetails extends StatefulWidget {
  final String courseName;

  Languagedetails({required this.courseName});

  @override
  _LanguagedetailsState createState() => _LanguagedetailsState();
}

class _LanguagedetailsState extends State<Languagedetails> {
  List<String> fetchedLectures = [];
  List<String> fetchedSummaries = [];
  List<String> fetchedExams = [];
  bool isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    fetchCourseData();
  }

  Future<void> fetchCourseData() async {
    try {
      // Fetch course details from Firestore for the selected course
      var courseDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc('Faculty_Of_Language') // Corrected to Faculty_Of_Language
          .collection('course_name')
          .doc(widget.courseName)
          .get();

      // Fetch arrays from Firestore
      var lecturesSnapshot = courseDoc.data()?['lecture'];
      var summariesSnapshot = courseDoc.data()?['summary'];
      var examsSnapshot = courseDoc.data()?['old_exam'];

      // Handle the fetched arrays
      setState(() {
        fetchedLectures = _extractArray(lecturesSnapshot);
        fetchedSummaries = _extractArray(summariesSnapshot);
        fetchedExams = _extractArray(examsSnapshot);
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching course data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Helper function to safely extract array from Firestore
  List<String> _extractArray(dynamic data) {
    if (data is List) {
      // Ensure that each item in the list is a string or null before returning
      return data.map((item) => item?.toString() ?? 'Unnamed Item').toList();
    } else {
      return [
        'Unnamed Item'
      ]; // Return a default value if the data isn't a List
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 2, // Two tabs: Material and Feedback
              child: Column(
                children: [
                  // TabBar for switching between course materials and feedback
                  TabBar(
                    tabs: [
                      Tab(text: 'Material'),
                      Tab(text: 'Feedback'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Material Content
                        ListView(
                          children: [
                            // Lecture Classification
                            ClassificationItem(
                              title: "Lecture",
                              items: fetchedLectures.isEmpty
                                  ? ['No Lectures Available']
                                  : fetchedLectures,
                            ),
                            // Summary Classification
                            ClassificationItem(
                              title: "Summary",
                              items: fetchedSummaries.isEmpty
                                  ? ['No Summaries Available']
                                  : fetchedSummaries,
                            ),
                            // Old Exam Classification
                            ClassificationItem(
                              title: "Old Exam",
                              items: fetchedExams.isEmpty
                                  ? ['No Old Exams Available']
                                  : fetchedExams,
                            ),
                          ],
                        ),
                        // Feedback Section - Assuming you have a Comments widget
                        Comments(courseId: widget.courseName),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ClassificationItem extends StatelessWidget {
  final String title;
  final List<String> items;

  const ClassificationItem({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ExpansionTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        children: items
            .map((item) => ListTile(
                  title: Text(item),
                ))
            .toList(),
      ),
    );
  }
}
