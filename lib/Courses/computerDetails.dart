import 'package:flutter/material.dart'; // Import Flutter material design package.
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for database interaction.
import 'package:salwa_app/Courses/classification.dart'; // Import the ClassificationItem widget.
import 'package:salwa_app/Courses/comments.dart'; // Import the Comments widget for feedback section.
import 'package:url_launcher/url_launcher.dart'; // Import URL launcher to open links.

class CoursePage extends StatefulWidget {
  final String courseName; // The name of the course to display.

  CoursePage({required this.courseName}); // Constructor to initialize the course name.

  @override
  _CoursePageState createState() => _CoursePageState(); // Create the state for this widget.
}

class _CoursePageState extends State<CoursePage> {
  List<String> fetchedLectures = []; // List to store lectures.
  List<String> fetchedSummaries = []; // List to store summaries.
  List<String> fetchedExams = []; // List to store old exams.
  String? fetchedOverview; // Variable to store the course overview.
  bool isLoading = true; // Flag to indicate loading state.

  @override
  void initState() {
    super.initState();
    fetchCourseData(); // Fetch course data when the widget initializes.
  }

  Future<void> fetchCourseData() async {
    // Fetch course data from Firestore.
    try {
      var courseDoc = await FirebaseFirestore.instance
          .collection('courses') // Access the 'courses' collection.
          .doc('Faculty_Of_Computer') // Access the document for the computer faculty.
          .collection('course_name') // Access the sub-collection with course names.
          .doc(widget.courseName) // Access the specific course document.
          .get();

      // Retrieve fields from the document.
      var lecturesSnapshot = courseDoc.data()?['lecture'];
      var summariesSnapshot = courseDoc.data()?['summary'];
      var examsSnapshot = courseDoc.data()?['old_exam'];
      var overviewSnapshot = courseDoc.data()?['overview'];

      setState(() {
        // Update the state with fetched data.
        fetchedLectures = _extractArray(lecturesSnapshot);
        fetchedSummaries = _extractArray(summariesSnapshot);
        fetchedExams = _extractArray(examsSnapshot);
        fetchedOverview = overviewSnapshot?.toString() ?? 'No Overview Available';
        isLoading = false; // Loading is complete.
      });
    } catch (e) {
      // Handle any errors during data fetching.
      print("Error fetching course data: $e");
      setState(() {
        isLoading = false; // Stop loading if there's an error.
      });
    }
  }

  // Helper method to safely extract data from Firestore fields.
  List<String> _extractArray(dynamic data) {
    if (data is List) {
      // Convert each item in the list to a string.
      return data.map((item) => item?.toString() ?? 'Unnamed Item').toList();
    } else {
      return ['Unnamed Item']; // Return default value if the data is invalid.
    }
  }

  // Method to launch a URL in an external browser.
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // Open the URL.
    } else {
      print('Could not launch $url'); // Log error if the URL cannot be launched.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName), // Display the course name in the AppBar.
      ),
      body: isLoading // Check if data is still loading.
          ? Center(child: CircularProgressIndicator()) // Show loading spinner.
          : DefaultTabController(
        length: 2, // Set the number of tabs (Material and Feedback).
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Material'), // Tab for course materials.
                Tab(text: 'Feedback'), // Tab for feedback section.
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    children: [
                      // Overview section
                      ClassificationItem(
                        title: "Overview",
                        items: fetchedOverview == null
                            ? ['No Overview Available']
                            : [fetchedOverview!], // Display the overview or default message.
                        onItemTap: (item) {
                          // Overview is text-only; no action needed on tap.
                        },
                      ),
                      // Lecture section
                      ClassificationItem(
                        title: "Recorded Lectures",
                        items: fetchedLectures.isEmpty
                            ? ['No Lectures Available']
                            : fetchedLectures, // Display lectures or default message.
                        onItemTap: (url) => _launchURL(url), // Open lecture links.
                      ),
                      // Summary section
                      ClassificationItem(
                        title: "Summary",
                        items: fetchedSummaries.isEmpty
                            ? ['No Summaries Available']
                            : fetchedSummaries, // Display summaries or default message.
                        onItemTap: (url) => _launchURL(url), // Open summary links.
                      ),
                      // Old Exam section
                      ClassificationItem(
                        title: "Old Exam",
                        items: fetchedExams.isEmpty
                            ? ['No Old Exams Available']
                            : fetchedExams, // Display exams or default message.
                        onItemTap: (url) => _launchURL(url), // Open exam links.
                      ),
                    ],
                  ),
                  // Feedback section
                  Comments(courseId: widget.courseName), // Load the Comments widget for feedback.
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

