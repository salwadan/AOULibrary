import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salwa_app/components/custombuttonauth.dart';
import 'package:salwa_app/components/customlogoauth.dart';
import 'package:salwa_app/components/textformfield.dart';
import 'package:salwa_app/homepage.dart';
import 'package:salwa_app/theAdmin/adminPage.dart'; // Import AdminPage here

// Login Page StatefulWidget
// Represents the login screen
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers for email and password text fields
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // Form key for validating the form inputs
  final _formKey = GlobalKey<FormState>();

  // Variables to display success or error messages
  String? _message;
  bool _isSuccessMessage = false;

  @override
  void initState() {
    super.initState();
    _checkUserSession(); // Check if the user is already logged in
  }

  // Function to check if a user is already logged in
  void _checkUserSession() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Query Firestore to check if the user is an admin
      final adminSnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .where('email', isEqualTo: user.email)
          .get();

      if (adminSnapshot.docs.isNotEmpty) {
        // Navigate to Admin Page if the user is an admin
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AdminPage(),
          ),
        );
      } else {
        // Navigate to homepage if the user is not an admin
        Navigator.of(context).pushReplacementNamed("homepage");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sets the background color of the screen
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      body: Container(
        // Padding around the content
        padding: const EdgeInsets.all(20),

        // Using ListView to ensure the content is scrollable
        child: ListView(
          children: [
            // Form widget to handle input validation
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom widget for displaying the app logo
                  const CustomLogoAuth(),
                  Container(height: 20), // Spacing between widgets

                  // Title: "Log in"
                  const Text(
                    "Log in",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 20),

                  // Email label and input field
                  const Text("Email",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter your Email", // Placeholder text
                    mycontroller: email, // Controller for email input
                    validator: (val) {
                      // Validation for the email field
                      if (val == null || val.isEmpty) {
                        return "The field can't be empty";
                      } else if (!val.contains('@')) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  Container(height: 10), // Spacing

                  // Password label and input field
                  const Text("Password",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter your Password", // Placeholder text
                    mycontroller: password, // Controller for password input
                    obscureText: true, // Hides the password text
                    validator: (val) {
                      // Validation for the password field
                      if (val == null || val.isEmpty) {
                        return "The field can't be empty";
                      }
                      return null;
                    },
                  ),

                  // Forgot Password Link
                  InkWell(
                    onTap: () async {
                      if (email.text.isEmpty) {
                        setState(() {
                          _message =
                              'Please enter your email first'; // Error message
                          _isSuccessMessage = false;
                        });
                        return;
                      }

                      try {
                        // Sends a password reset email
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email.text);
                        setState(() {
                          _message =
                              'A link to reset your password has been sent to you';
                          _isSuccessMessage = true;
                        });
                      } catch (e) {
                        setState(() {
                          _message = 'Make sure the entered email is correct';
                          _isSuccessMessage = false;
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      alignment: Alignment.topRight,
                      child: const Text(
                        "Forgot password?",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),

                  // Displays success or error messages
                  if (_message != null)
                    Text(
                      _message!,
                      style: TextStyle(
                        color: _isSuccessMessage ? Colors.green : Colors.red,
                      ),
                    ),
                ],
              ),
            ),

            // Log in Button
            CustomButtonAuth(
              title: "Log in",
              buttonColor: const Color.fromARGB(255, 4, 6, 93), // Button color
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    // Firebase Authentication to sign in
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email.text, password: password.text);

                    // Query Firestore to check if the user is an admin
                    final adminSnapshot = await FirebaseFirestore.instance
                        .collection('admin')
                        .where('email', isEqualTo: email.text)
                        .get();

                    if (adminSnapshot.docs.isNotEmpty) {
                      // Navigate to Admin Page if the user is an admin
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const AdminPage(),
                        ),
                      );
                    } else if (FirebaseAuth
                        .instance.currentUser!.emailVerified) {
                      // ignore: prefer_interpolation_to_compose_strings
                      print("Verification Status => " +
                          FirebaseAuth.instance.currentUser!.emailVerified
                              .toString());
                      // Navigate to homepage if the user is not an admin but email is verified
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Homepage(),
                        ),
                      );
                    } else {
                      // Prompt user to verify their email
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      setState(() {
                        _message = 'Please verify your email.';
                        _isSuccessMessage = false;
                      });
                    }
                  } on FirebaseAuthException catch (e) {
                    // Handle specific Firebase authentication errors
                    if (e.code == 'user-not-found') {
                      setState(() {
                        _message = 'The email address is not registered.';
                        _isSuccessMessage = false;
                      });
                    } else if (e.code == 'wrong-password') {
                      setState(() {
                        _message = 'Incorrect password provided.';
                        _isSuccessMessage = false;
                      });
                    }
                  }
                } else {
                  print("Form is not valid"); // Debugging message
                }
              },
            ),
            Container(height: 6), // Spacing

            // Sign up Link
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed("signup"); // Navigate to sign-up page
              },
              child: const Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                    text: "Don't have an account?",
                  ),
                  TextSpan(
                    text: " Sign up",
                    style: TextStyle(
                        color: Color.fromARGB(255, 4, 6, 93),
                        fontWeight: FontWeight.bold),
                  ),
                ])),
              ),
            ),
            Container(height: 6), // Spacing

            // "Or" Divider
            const Text(
              "Or",
              textAlign: TextAlign.center,
            ),
            Container(height: 6), // Spacing

            // Continue as Guest Button
            CustomButtonAuth(
              title: "Continue as a guest",
              buttonColor:
                  const Color.fromARGB(255, 56, 101, 217), // Button color
              onPressed: () {
                // Navigate to homepage as a guest
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Homepage(isGuest: true),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
