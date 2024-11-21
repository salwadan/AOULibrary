import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  final String courseId; // Course ID to filter comments to specific to a course
  const Comments({Key? key, required this.courseId}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _commentController = TextEditingController(); // Controller for the comment input field
  String username = 'Anonymous'; // Default username if not fetched


  @override
  void initState() {
    super.initState();
    fetchUsername(); // Fetch the current user's username , logged-in user's username
  }


  // Function to fetch the username of the logged-in user

  Future<void> fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;   // Get the current user
    if (user != null) {
      // Query the 'users' collection using the user's email to find the username
      final userDocs = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      if (userDocs.docs.isNotEmpty) {
        // Set the username from the fetched document data , If data exists, update the username
        setState(() {
          username = userDocs.docs.first['name'] ?? 'Anonymous';
        });
        print("Fetched username: $username"); // Debugging statement print fetched username

      } else {
        print("No user data found for this email.");  // Debugging: no user data
      }
    } else {
      print("User is not logged in."); // Debugging: user not logged in
    }
  }

  // Function to add a new comment to Firestore
  Future<void> addComment() async {
    final user = FirebaseAuth.instance.currentUser;   // Get the current user
    if (user == null) {
      // If the user is not logged in, show a dialog to prompt them to log in
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Required'),
          content: const Text('You must be logged in to submit feedback.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return; // Do not proceed with adding the comment Exit the function if the user is not logged in
    }


    final commentText = _commentController.text.trim();  // Get and trim the comment text

    if (commentText.isNotEmpty) {
      try {
        // Add a new comment document to the 'comments' collection in Firestore
        await FirebaseFirestore.instance.collection('comments').add({
          'course_id': widget.courseId, // Associate the comment with the course
          'text': commentText, // Comment text
          'time': FieldValue.serverTimestamp(), // Timestamp of the comment
          'username': username, // Username of the commenter
        });
        _commentController.clear(); // Clear the input field after submission


        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Feedback submitted successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // Handle any errors that occur during submission
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit feedback. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Show a warning message if the input field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your feedback before submitting.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Comment input field at the bottom
          Positioned(
            bottom: 0,
            child: Container(
              color: Colors.white, // Background color for the input field
              height: 60, // Height of the input field container
              width: MediaQuery.of(context).size.width, // Height of the input field container
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _commentController, // Bind input controller
                      decoration: InputDecoration(
                        hintText: "Enter your feedback here", // Placeholder text
                        filled: true,
                        fillColor: Colors.grey[200],// Background color of input field
                        contentPadding: EdgeInsets.all(10), // Padding inside the input field
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey), // Border color

                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: addComment, // Call addComment on button press
                    icon: Icon(Icons.send),  // Send icon
                    color: Colors.blue, // Icon color
                  ),
                ],
              ),
            ),
          ),

          // List of comments displayed above the input field
          Positioned(
            top: 10,
            bottom: 60,  // Leave space for the input field at the bottom
            child: Container(
              width: MediaQuery.of(context).size.width, // Full width of the screen
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('comments') // Fetch comments collection
                    .where('course_id', isEqualTo: widget.courseId) // Filter by course ID
                    .orderBy('time',   // Order comments by time
                        descending: false) // Order by time (newest first)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator()); // Show loading indicator

                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No comments yet.")); // Show message if no comments

                  }
                  final comments = snapshot.data!.docs;   // List of comments
                  return ListView.builder(
                    itemCount: comments.length,  // Total number of comments
                    itemBuilder: (context, index) {
                      var comment = comments[index];    // Current comment
                      return ListTile(
                        leading: CircleAvatar(child: Icon(Icons.person)), // Placeholder user avatar
                        title: Text(comment['username'] ?? 'Anonymous'),   // Display username
                        subtitle: Container(
                          padding: EdgeInsets.all(10),   // Padding inside the comment box
                          color: Colors.grey[100],   // Background color for the comment
                          child: Text(comment['text']),// Display comment text
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
