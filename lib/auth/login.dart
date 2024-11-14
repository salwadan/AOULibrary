import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/components/custombuttonauth.dart';
import 'package:salwa_app/components/customlogoauth.dart';
import 'package:salwa_app/components/textformfield.dart';
import 'package:salwa_app/homepage.dart';

// Login screen widget
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers for email and password input fields
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  
  // Global key to manage form validation
  final _formKey = GlobalKey<FormState>();

  // Variables for displaying feedback messages
  String? _message;
  bool _isSuccessMessage = false; // To control success/error message color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Background color of the screen
      body: Container(
        padding: const EdgeInsets.all(20), // Padding for the content
        child: ListView(
          children: [
            // Form widget to validate and manage email/password inputs
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 1),
                  const CustomLogoAuth(), // Custom logo for authentication screen
                  Container(height: 20),
                  
                  // Title: Log in
                  const Text(
                    "Log in",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 20),
                  
                  // Email input field
                  const Text("Email",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter your Email",
                    mycontroller: email,
                    validator: (val) {
                      // Email validation
                      if (val == null || val.isEmpty) {
                        return "The field can't be empty";
                      } else if (!val.contains('@')) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  Container(height: 10),
                  
                  // Password input field
                  const Text("Password",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter your Password",
                    mycontroller: password,
                    obscureText: true, // Hides the password input
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "The field can't be empty";
                      }
                      return null;
                    },
                  ),
                  
                  // Forgot password option
                  InkWell(
                    onTap: () async {
                      // Handle forgot password logic
                      if (email.text.isEmpty) {
                        setState(() {
                          _message = 'Please enter your email first';
                          _isSuccessMessage = false; // Red message
                        });
                        return;
                      }

                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email.text);
                        setState(() {
                          _message =
                              'A link to reset your password has been sent to you';
                          _isSuccessMessage = true; // Green message
                        });
                      } catch (e) {
                        setState(() {
                          _message = 'Make sure the entered email is correct';
                          _isSuccessMessage = false; // Red message
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
                  
                  // Display success or error message based on the result of actions
                  if (_message != null)
                    Text(
                      _message!,
                      style: TextStyle(
                        color: _isSuccessMessage
                            ? Colors.green // Success message in green
                            : Colors.red, // Error message in red
                      ),
                    ),
                ],
              ),
            ),

            // Log in button
            CustomButtonAuth(
              title: "Log in",
              buttonColor: const Color.fromARGB(255, 4, 6, 93),
              onPressed: () async {
                // Handle the login logic
                if (_formKey.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email.text, password: password.text);
                    
                    // Check if email is verified
                    if (credential.user!.emailVerified) {
                      Navigator.of(context).pushReplacementNamed("homepage");
                    } else {
                      // Send verification email if not verified
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      setState(() {
                        _message = 'Please verify your email.';
                        _isSuccessMessage = false; // Red message
                      });
                    }
                  } on FirebaseAuthException catch (e) {
                    // Handle specific FirebaseAuthException errors
                    if (e.code == 'user-not-found') {
                      setState(() {
                        _message = 'The email address is not registered.';
                        _isSuccessMessage = false; // Red message
                      });
                    } else if (e.code == 'wrong-password') {
                      setState(() {
                        _message = 'Incorrect password provided.';
                        _isSuccessMessage = false; // Red message
                      });
                    }
                  }
                } else {
                  print("Form is not valid");
                }
              },
            ),

            Container(height: 6),

            // Navigate to sign-up page if user doesn't have an account
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("signup");
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
            Container(height: 6),
            
            // Separator text "Or"
            const Text(
              "Or",
              textAlign: TextAlign.center,
            ),
            Container(height: 6),

            // Continue as a guest button
            CustomButtonAuth(
              title: "Continue as a guest",
              buttonColor: const Color.fromARGB(255, 56, 101, 217),
              onPressed: () {
                // Navigate to the homepage as a guest user
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
