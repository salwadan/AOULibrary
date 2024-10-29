import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/components/custombuttonauth.dart';
import 'package:salwa_app/components/customlogoauth.dart';
import 'package:salwa_app/components/textformfield.dart';
import 'package:salwa_app/homepage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _message;
  bool _isSuccessMessage = false; // New state variable to control message color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 1),
                  const CustomLogoAuth(),
                  Container(height: 20),
                  const Text(
                    "Log in",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 20),
                  const Text("Email",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter your Email",
                    mycontroller: email,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "The field can't be empty";
                      } else if (!val.contains('@')) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  Container(height: 10),
                  const Text("Password",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter your Password",
                    mycontroller: password,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "The field can't be empty";
                      }
                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      if (email.text.isEmpty) {
                        setState(() {
                          _message = 'Please enter your email first';
                          _isSuccessMessage = false; // Ensure red color
                        });
                        return;
                      }

                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email.text);
                        setState(() {
                          _message =
                              'A link to reset your password has been sent to you';
                          _isSuccessMessage =
                              true; // Set to true for green color
                        });
                      } catch (e) {
                        setState(() {
                          _message = 'Make sure the entered email is correct';
                          _isSuccessMessage = false; // Ensure red color
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      alignment: Alignment.topRight,
                      child: const Text("Forgot password?",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  if (_message != null) // Display the message
                    Text(
                      _message!,
                      style: TextStyle(
                        color: _isSuccessMessage
                            ? Colors.green
                            : Colors.red, // Green for success
                      ),
                    ),
                ],
              ),
            ),
            CustomButtonAuth(
              title: "Log in",
              buttonColor: const Color.fromARGB(255, 4, 6, 93),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email.text, password: password.text);
                    if (credential.user!.emailVerified) {
                      Navigator.of(context).pushReplacementNamed("homepage");
                    } else {
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      setState(() {
                        _message = 'Please verify your email.';
                        _isSuccessMessage = false; // Red color for this message
                      });
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      setState(() {
                        _message = 'The email address is not registered.';
                        _isSuccessMessage = false; // Red color for error
                      });
                    } else if (e.code == 'wrong-password') {
                      setState(() {
                        _message = 'Incorrect password provided.';
                        _isSuccessMessage = false; // Red color for error
                      });
                    }
                  }
                } else {
                  print("Not valid");
                }
              },
            ),
            Container(height: 6),
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
            const Text(
              "Or",
              textAlign: TextAlign.center,
            ),
            Container(height: 6),
            CustomButtonAuth(
              title: "Continue as a guest",
              buttonColor: const Color.fromARGB(255, 56, 101, 217),
              onPressed: () {  Navigator.of(context).pushReplacement(    
                MaterialPageRoute(        
                  builder: (context) =>  Homepage(isGuest: true),    ),  );},
            ),
          ],
        ),
      ),
    );
  }
}
