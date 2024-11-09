import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/components/custombuttonauth.dart';
import 'package:salwa_app/components/customlogoauth.dart';
import 'package:salwa_app/components/textformfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 1),
                  const CustomLogoAuth(),
                  Container(height: 20),
                  const Text(
                    "Sign up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 20),
                  const Text("Name",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter your name",
                    mycontroller: username,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "The field can't be empty";
                      }
                      return null;
                    },
                  ),
                  Container(height: 10),
                  const Text("Email",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter your Email",
                    mycontroller: email,
                    validator: (val) {
                      if (val == null ||
                          val.trim().isEmpty ||
                          !val.contains('@')) {
                        return "The field can't be empty";
                      } else if (!val.endsWith('edu.sa')) {
                        return 'Please use a valid university email ending with edu.sa';
                      }
                      return null;
                    },
                    errorText: _emailError,
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
                      if (val == null || val.trim().isEmpty) {
                        return "The field can't be empty";
                      } else if (val.length < 6) {
                        return 'The password provided is too weak.';
                      } else if (!RegExp(r'[A-Z]').hasMatch(val)) {
                        return 'The password must contain at least one uppercase letter.';
                      }
                      return null;
                    },
                    errorText: _passwordError,
                    obscureText: true, // Enable password obscuring
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                  ),
                ],
              ),
            ),
            CustomButtonAuth(
              title: "Sign up",
              buttonColor: const Color.fromARGB(255, 4, 6, 93),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (!email.text.trim().endsWith('edu.sa')) {
                    setState(() {
                      _emailError =
                          'Please use a valid university email ending with edu.sa';
                    });
                    return;
                  }
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();

                    // Add user information to Firestore
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(credential.user?.uid)
                        .set({
                      'name': username.text,
                      'email': email.text,
                      'password': password.text
                    }).then((value) {
                      Navigator.of(context).pushReplacementNamed("login");
                    }).catchError((error) {
                      print("Failed to add user: $error");
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      setState(() {
                        _passwordError = 'The password provided is too weak.';
                      });
                    } else if (e.code == 'email-already-in-use') {
                      setState(() {
                        _emailError =
                            'The account already exists for that email.';
                      });
                    }
                  } catch (e) {
                    print(e);
                  }
                }
              },
            ),
            Container(height: 6),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("login");
              },
              child: const Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                    text: "Have an account?",
                  ),
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
