import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import 'package:firebase_core/firebase_core.dart'; // For Firebase initialization
import 'package:flutter/material.dart'; // Flutter framework core package
import 'package:salwa_app/auth/login.dart'; // Custom Login page
import 'package:salwa_app/auth/signup.dart'; // Custom Signup page

import 'package:salwa_app/homepage.dart'; // Custom Homepage
import 'package:device_preview/device_preview.dart';
import 'package:salwa_app/welcomescreen.dart';

import 'firbase/firebase_options.dart'; // For previewing UI on various devices

Future<void> main() async {
  // Ensures that widget binding is initialized before app setup
  WidgetsFlutterBinding.ensureInitialized();
  // Initializes Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Runs the app with device preview for debugging on multiple device screens
  runApp(DevicePreview(builder: (context) => const MyApp()));
}

// Root widget for the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disables the debug banner
      builder: DevicePreview.appBuilder, // Wraps the app with Device Preview
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true, // Centers AppBar title
          backgroundColor: const Color.fromARGB(255, 194, 214, 231), // AppBar background color
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 37, 55, 187),
              fontSize: 20,
              fontWeight: FontWeight.bold),
          iconTheme:
          const IconThemeData(color: Color.fromARGB(255, 37, 55, 187)), // Icon color in AppBar
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Color scheme
        useMaterial3: true, // Enables Material 3 design
      ),
      // Initial route set to WelcomeScreen
      home: const WelcomeScreen(),
      routes: {
        "signup": (context) => const SignUp(), // Route to Signup page
        "login": (context) => const Login(), // Route to Login page
        "homepage": (context) => Homepage() // Route to Homepage
      },
    );
  }
}
