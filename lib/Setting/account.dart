import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/components/custombuttonauth.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // Text controller for the user's name input field
  final TextEditingController _nameController = TextEditingController();

  // Firebase Authentication and Firestore instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Store the current user's unique ID
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load the current user data when the page loads
  }

  /// Loads the user's name from Firestore and sets it in the name field.
  Future<void> _loadUserData() async {
    User? user = _auth.currentUser; // Get the current authenticated user
    if (user != null) {
      userId = user.uid; // Retrieve the user's unique ID
      // Access Firestore to get the user's document by their ID
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        setState(() {
          _nameController.text = userDoc['name'] ?? ''; // Set the name field from Firestore
        });
      }
    }
  }

  /// Updates the user's name in Firestore when the Submit button is clicked.
  Future<void> _updateUserName() async {
    if (userId.isNotEmpty) {
      await _firestore.collection('users').doc(userId).update({
        'name': _nameController.text, // Update Firestore with new name
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name updated successfully')), // Show success message
      );
    }
  }

  /// Updates the user's password in Firestore (optional) if you store passwords.
  Future<void> _updatePassword(String newPassword) async {
    if (userId.isNotEmpty) {
      await _firestore.collection('users').doc(userId).update({
        'password': newPassword, // Update password in Firestore (optional)
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password updated successfully')), // Show success message
      );
    }
  }

  /// Displays a dialog to change the user's password with current password re-authentication.
  void _showPasswordChangeDialog() {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Change Password"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Input field for the current password
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Current Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                // Input field for the new password
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                // Input field for confirming the new password
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // Cancel button to close the dialog without changes
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            // Submit button to validate and update the password
            ElevatedButton(
              onPressed: () async {
                // Verify if the new passwords match
                if (newPasswordController.text == confirmPasswordController.text) {
                  try {
                    // Retrieve the current user and re-authenticate with their current password
                    User? user = _auth.currentUser;
                    if (user != null) {
                      AuthCredential credential = EmailAuthProvider.credential(
                        email: user.email!,
                        password: currentPasswordController.text,
                      );

                      // Re-authenticate to confirm the current password
                      await user.reauthenticateWithCredential(credential);

                      // If re-authentication is successful, update the password
                      await user.updatePassword(newPasswordController.text);
                      _updatePassword(newPasswordController.text); // Optional Firestore update
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Password updated successfully")),
                      );

                      Navigator.of(context).pop(); // Close the dialog after success
                    }
                  } catch (error) {
                    // Display an error if re-authentication fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Current password is incorrect")),
                    );
                  }
                } else {
                  // Display an error if the new passwords do not match
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Passwords do not match")),
                  );
                }
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Information"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        color: const Color.fromARGB(255, 214, 213, 213),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            SizedBox(width: 10),
            // Display label for the Name field
            Text(
              '   Name :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 15),
            // Name input field with a hint style
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 86, 86, 86)),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Submit button to update the user's name in Firestore
            CustomButtonAuth(
              title: "Submit",
              buttonColor: const Color.fromRGBO(4, 6, 93, 1), // Navy color
              onPressed: _updateUserName,
              width: double.infinity,
            ),
            SizedBox(height: 15),
            // Display label for the Password section
            Text(
              '   Password :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 15),
            // Button to open the password change dialog
            CustomButtonAuth(
              title: "Change Password",
              buttonColor: const Color.fromARGB(255, 56, 101, 217),
              onPressed: _showPasswordChangeDialog,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
