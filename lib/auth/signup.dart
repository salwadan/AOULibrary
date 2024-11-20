import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/components/custombuttonauth.dart';
import 'package:salwa_app/components/customlogoauth.dart';
import 'package:salwa_app/components/textformfield.dart';

// SignUp page where users can register
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Controllers for the form fields
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // GlobalKey to access the FormState for validation
  final _formKey = GlobalKey<FormState>();

  // Error messages for email and password fields
  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Form widget to hold and validate form fields
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Logo
                  Container(height: 1),
                  const CustomLogoAuth(),
                  Container(height: 20),
                  
                  // Title for the page
                  const Text(
                    "Sign up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 20),
                  
                  // Name input field
                  const Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter your name",
                    mycontroller: username,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "The field can't be empty";
                      }
                      return null; // Return null if validation passes
                    },
                  ),
                  Container(height: 10),

                  // Email input field with validation for format and domain
                  const Text("Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter your Email",
                    mycontroller: email,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty || !val.contains('@')) {
                        return "The field can't be empty";
                      } else if (!val.endsWith('edu.sa')) {
                        return 'Please use a valid university email ending with edu.sa';
                      }
                      return null; // Return null if validation passes
                    },
                    errorText: _emailError,
                  ),
                  Container(height: 10),

                  // Password input field with validation for length and complexity
                  const Text("Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter your Password",
                    mycontroller: password,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "The field can't be empty";
                      } else if (val.length < 6) {
                        return 'The password provided is too weak.';
                      } else if (!RegExp(r'[A-Z]').hasMatch(val)) {
                        return 'The password must contain at least one uppercase letter.';
                      }
                      return null; // Return null if validation passes
                    },
                    errorText: _passwordError,
                    obscureText: true, // Hide password input
                  ),
                  Container(margin: const EdgeInsets.only(top: 10, bottom: 20)),
                ],
              ),
            ),

            // Sign up button, triggers form validation and user creation
            CustomButtonAuth(
              title: "Sign up",
              buttonColor: const Color.fromARGB(255, 4, 6, 93),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Check if the email ends with 'edu.sa'
                  if (!email.text.trim().endsWith('edu.sa')) {
                    setState(() {
                      _emailError = 'Please use a valid university email ending with edu.sa';
                    });
                    return; // Stop execution if email is invalid
                  }

                  try {
                    // Create a user with the provided email and password
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );

                    // Send email verification to the newly created user
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();

                    // Add user details to Firestore
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(credential.user?.uid)
                        .set({
                      'name': username.text,
                      'email': email.text,
                      'password': password.text
                    }).then((value) {
                      // Navigate to the login screen after successful sign up
                      Navigator.of(context).pushReplacementNamed("login");
                    }).catchError((error) {
                      print("Failed to add user: $error");
                    });
                  } on FirebaseAuthException catch (e) {
                    // Handle Firebase authentication errors
                    if (e.code == 'weak-password') {
                      setState(() {
                        _passwordError = 'The password provided is too weak.';
                      });
                    } else if (e.code == 'email-already-in-use') {
                      setState(() {
                        _emailError = 'The account already exists for that email.';
                      });
                    }
                  } catch (e) {
                    print(e); // Catch any other errors
                  }
                }
              },
            ),

            // Spacer before the login link
            Container(height: 6),

            // Login redirect link, directs to the login page
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("login");
              },
              child: const Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: "Have an account?"),
                  TextSpan(
                    text: " Log in",
                    style: TextStyle(
                        color: Color.fromARGB(255, 4, 6, 93),
                        fontWeight: FontWeight.bold),
                  ),
                ])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
