import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'comments.dart'; // Assuming you have a Comments widget for feedback
import 'package:url_launcher/url_launcher.dart';
import 'package:salwa_app/Courses/classification.dart';
class Businessdetails extends StatefulWidget {
  final String courseName;

  Businessdetails({required this.courseName});

  @override
  _BusinessdetailsState createState() => _BusinessdetailsState();
}

class _BusinessdetailsState extends State<Businessdetails> {
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
          .doc('Faculty_Of_Business') // Adjust as needed
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
      return data.map((item) => item?.toString() ?? 'Unnamed Item').toList();
    } else {
      return [
        'Unnamed Item'
      ]; // Return a default value if the data isn't a List
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
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
                            // Lecture Classification with URL launcher
                            ClassificationItem(
                              title: "Lecture",
                              items: fetchedLectures.isEmpty
                                  ? ['No Lectures Available']
                                  : fetchedLectures,
                              onItemTap: (url) => _launchURL(url),
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

