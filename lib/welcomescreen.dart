// ignore: file_names
import 'dart:async';
import 'package:flutter/material.dart';

import 'auth/login.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // Background image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'), // Your background image
              fit: BoxFit.cover, // Make sure the image covers the entire screen
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                width: 20,
              ),
              Image.asset(
                "assets/aou_logo.png",
                width: 250,
                height: 250,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              const SizedBox(
                height: 230,
                width: 80,
              ),


              ClipOval(
                child: Image.asset(
                  'assets/AOU.jpg', // Replace with your image path
                  width: 120, // Set the desired width
                  height: 120, // Set the desired height
                  fit: BoxFit.fitWidth, //
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Center(
                child: Text(
                  " Welcome to Arab  ",
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 3, 34, 59),
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                " Open University Library ",
                style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 3, 34, 59),
                    fontWeight: FontWeight.bold),
              ),

            ],
          ),
        ),
      ]),
    );
  }
}

@override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'AOU Library',

    home: WelcomeScreen(), // Set WelcomeScreen as the initial screen
  );
}
