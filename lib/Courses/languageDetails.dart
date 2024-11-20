import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salwa_app/Courses/classification.dart';
import 'comments.dart'; // Assuming you have a Comments widget for feedback
import 'package:url_launcher/url_launcher.dart'; // Import the URL launcher package

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
  String? fetchedOverview; // For storing the overview text
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourseData();
  }

  Future<void> fetchCourseData() async {
    try {
      var courseDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc('Faculty_Of_Language')
          .collection('course_name')
          .doc(widget.courseName)
          .get();

      var lecturesSnapshot = courseDoc.data()?['lecture'];
      var summariesSnapshot = courseDoc.data()?['summary'];
      var examsSnapshot = courseDoc.data()?['old_exam'];
      var overviewSnapshot = courseDoc.data()?['overview'];

      setState(() {
        fetchedLectures = _extractArray(lecturesSnapshot);
        fetchedSummaries = _extractArray(summariesSnapshot);
        fetchedExams = _extractArray(examsSnapshot);
        fetchedOverview = overviewSnapshot?.toString() ?? 'No Overview Available';
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching course data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<String> _extractArray(dynamic data) {
    if (data is List) {
      return data.map((item) => item?.toString() ?? 'Unnamed Item').toList();
    } else {
      return ['Unnamed Item'];
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
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Material'),
                      Tab(text: 'Feedback'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            // Overview Section
                            ClassificationItem(
                              title: "Overview",
                              items: fetchedOverview == null
                                  ? ['No Overview Available']
                                  : [fetchedOverview!],
                              onItemTap: (item) {
                                // Do nothing; overview is static text
                              },
                            ),
                            // Lecture Section
                            ClassificationItem(
                              title: "Lecture",
                              items: fetchedLectures.isEmpty
                                  ? ['No Lectures Available']
                                  : fetchedLectures,
                              onItemTap: (url) => _launchURL(url),
                            ),
                            // Summary Section
                            ClassificationItem(
                              title: "Summary",
                              items: fetchedSummaries.isEmpty
                                  ? ['No Summaries Available']
                                  : fetchedSummaries,
                              onItemTap: (url) => _launchURL(url),
                            ),
                            // Old Exam Section
                            ClassificationItem(
                              title: "Old Exam",
                              items: fetchedExams.isEmpty
                                  ? ['No Old Exams Available']
                                  : fetchedExams,
                              onItemTap: (url) => _launchURL(url),
                            ),
                          ],
                        ),
                        // Feedback Section
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
