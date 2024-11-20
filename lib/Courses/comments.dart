import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  final String courseId; // Course ID to filter comments
  const Comments({Key? key, required this.courseId}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _commentController = TextEditingController();
  String username = 'Anonymous';

  @override
  void initState() {
    super.initState();
    fetchUsername(); // Fetch the current user's username
  }

  // Fetch the username of the logged-in user
  Future<void> fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Query the 'users' collection using the user's email to find the username
      final userDocs = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      if (userDocs.docs.isNotEmpty) {
        // Set the username from the fetched document data
        setState(() {
          username = userDocs.docs.first['name'] ?? 'Anonymous';
        });
        print("Fetched username: $username"); // Debugging statement
      } else {
        print("No user data found for this email.");
      }
    } else {
      print("User is not logged in.");
    }
  }

  // Function to add a comment to Firestore
  Future<void> addComment() async {
    final user = FirebaseAuth.instance.currentUser;
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
      return; // Do not proceed with adding the comment
    }

    final commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('comments').add({
          'course_id': widget.courseId,
          'text': commentText,
          'time': FieldValue.serverTimestamp(),
          'username': username,
        });
        _commentController.clear();

        // Show a confirmation Snackbar
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
      // Show a Snackbar if the comment field is empty
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
          // Comment input field
          Positioned(
            bottom: 0,
            child: Container(
              color: Colors.white,
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: "Enter your feedback here",
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: addComment,
                    icon: Icon(Icons.send),
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),

          // Display the list of comments
          Positioned(
            top: 10,
            bottom: 60,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('comments')
                    .where('course_id', isEqualTo: widget.courseId)
                    .orderBy('time',
                        descending: false) // Order by time (newest first)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No comments yet."));
                  }
                  final comments = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      var comment = comments[index];
                      return ListTile(
                        leading: CircleAvatar(child: Icon(Icons.person)),
                        title: Text(comment['username'] ?? 'Anonymous'),
                        subtitle: Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.grey[100],
                          child: Text(comment['text']),
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
