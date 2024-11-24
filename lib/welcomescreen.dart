import 'dart:async'; // For using Timer

import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication package
import 'package:flutter/cupertino.dart'; // For Cupertino widgets (iOS-style widgets)
import 'package:flutter/material.dart'; // For Material Design widgets
import 'package:salwa_app/homepage.dart'; // Custom homepage widget

import 'auth/login.dart'; // Custom login page widget
import 'homepage.dart'; // Custom homepage widget

// WelcomeScreen class that shows a splash screen and navigates based on authentication status
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // Timer to delay navigation for 10 seconds before checking user authentication
    Timer(const Duration(seconds: 10), () {
      // Check if user is authenticated and email is verified
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified) {
        // If authenticated, navigate to the Homepage
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homepage()));
      } else {
        // Otherwise, navigate to the Login page
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The main body of the WelcomeScreen
      body: Stack(children: [
        // Background image for the splash screen
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'), // Background image
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center elements vertically
            children: [
              // Display the AOU logo in the center
              Image.asset(
                "assets/aou_logo.png", // Path to the AOU logo image
                width: 250,
                height: 250,
              ),
              const SizedBox(height: 200), // Space between logo and circular image
              // Display circular image of AOU
              ClipOval(
                child: Image.asset(
                  'assets/AOU.jpg', // Path to the circular image
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain, // Maintain the aspect ratio of the image
                ),
              ),
              const SizedBox(height: 40), // Space between image and welcome text
              // Welcome text displayed below the image
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
