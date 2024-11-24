import 'package:flutter/material.dart'; // Flutter Material Design package.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore integration.
import 'package:salwa_app/Courses/classification.dart'; // Custom ClassificationItem widget.
import 'comments.dart'; // Assuming a Comments widget for feedback.
import 'package:url_launcher/url_launcher.dart'; // To launch URLs in the browser or external apps.

class Languagedetails extends StatefulWidget {
  final String courseName; // The name of the course passed from the previous screen.

  Languagedetails({required this.courseName}); // Constructor with required courseName.

  @override
  _LanguagedetailsState createState() => _LanguagedetailsState(); // Create state for this widget.
}

class _LanguagedetailsState extends State<Languagedetails> {
  List<String> fetchedLectures = []; // List to store lecture links.
  List<String> fetchedSummaries = []; // List to store summary links.
  List<String> fetchedExams = []; // List to store old exam links.
  String? fetchedOverview; // Variable to store course overview text.
  bool isLoading = true; // Loading state indicator.

  @override
  void initState() {
    super.initState();
    fetchCourseData(); // Fetch course data when the widget is initialized.
  }

  // Function to fetch course data from Firestore.
  Future<void> fetchCourseData() async {
    try {
      // Get course document from Firestore.
      var courseDoc = await FirebaseFirestore.instance
          .collection('courses') // Main collection for courses.
          .doc('Faculty_Of_Language') // Document for Language Faculty.
          .collection('course_name') // Subcollection for course names.
          .doc(widget.courseName) // Document for the specific course.
          .get();

      // Extract data from the document.
      var lecturesSnapshot = courseDoc.data()?['lecture'];
      var summariesSnapshot = courseDoc.data()?['summary'];
      var examsSnapshot = courseDoc.data()?['old_exam'];
      var overviewSnapshot = courseDoc.data()?['overview'];

      setState(() {
        // Update state with the fetched data.
        fetchedLectures = _extractArray(lecturesSnapshot);
        fetchedSummaries = _extractArray(summariesSnapshot);
        fetchedExams = _extractArray(examsSnapshot);
        fetchedOverview = overviewSnapshot?.toString() ?? 'No Overview Available';
        isLoading = false; // Stop loading.
      });
    } catch (e) {
      print("Error fetching course data: $e"); // Log error if fetching fails.
      setState(() {
        isLoading = false; // Stop loading even if there's an error.
      });
    }
  }

  // Helper function to extract data as a list of strings.
  List<String> _extractArray(dynamic data) {
    if (data is List) {
      return data.map((item) => item?.toString() ?? 'Unnamed Item').toList();
    } else {
      return ['Unnamed Item']; // Return placeholder if data is not a list.
    }
  }

  // Function to launch a URL in an external application.
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url); // Parse the URL.
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // Launch the URL.
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
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show a loading spinner while data is being fetched.
          : DefaultTabController(
        length: 2, // Two tabs: Material and Feedback.
        child: Column(
          children: [
            // Tab bar with two tabs.
            TabBar(
              tabs: [
                Tab(text: 'Material'), // Tab for course materials.
                Tab(text: 'Feedback'), // Tab for feedback.
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Material Tab content.
                  ListView(
                    children: [
                      // Overview Section.
                      ClassificationItem(
                        title: "Overview", // Section title.
                        items: fetchedOverview == null
                            ? ['No Overview Available'] // Fallback if no overview is available.
                            : [fetchedOverview!],
                        onItemTap: (item) {
                          // Do nothing; overview is static text.
                        },
                      ),
                      // Lecture Section.
                      ClassificationItem(
                        title: "Recorded Lectures", // Section title.
                        items: fetchedLectures.isEmpty
                            ? ['No Lectures Available'] // Fallback if no lectures are available.
                            : fetchedLectures,
                        onItemTap: (url) => _launchURL(url), // Launch URL on tap.
                      ),
                      // Summary Section.
                      ClassificationItem(
                        title: "Summary", // Section title.
                        items: fetchedSummaries.isEmpty
                            ? ['No Summaries Available'] // Fallback if no summaries are available.
                            : fetchedSummaries,
                        onItemTap: (url) => _launchURL(url), // Launch URL on tap.
                      ),
                      // Old Exam Section.
                      ClassificationItem(
                        title: "Old Exam", // Section title.
                        items: fetchedExams.isEmpty
                            ? ['No Old Exams Available'] // Fallback if no old exams are available.
                            : fetchedExams,
                        onItemTap: (url) => _launchURL(url), // Launch URL on tap.
                      ),
                    ],
                  ),
                  // Feedback Tab content.
                  Comments(courseId: widget.courseName), // Widget to handle feedback.
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
