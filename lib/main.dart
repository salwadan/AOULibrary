import 'package:auto_size_text/auto_size_text.dart'; // For responsive text resizing
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import 'package:firebase_core/firebase_core.dart'; // For Firebase initialization
import 'package:flutter/material.dart'; // Flutter framework core package
import 'package:salwa_app/auth/login.dart'; // Custom Login page
import 'package:salwa_app/auth/signup.dart'; // Custom Signup page
import 'package:salwa_app/firbase/firebase_options.dart'; // Firebase configuration options
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore database operations
import 'package:salwa_app/homepage.dart'; // Custom Homepage
import 'package:device_preview/device_preview.dart'; // For previewing UI on various devices

/// Main function: Entry point of the app
Future<void> main() async {
  // Ensures that widget binding is initialized before app setup
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Runs the app with device preview for debugging on multiple device screens
  runApp(DevicePreview(builder: (context) => const MyApp()));
}

/// Root widget for the application
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
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Color.fromARGB(255, 37, 55, 187)), // Icon color in AppBar
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Color scheme
        useMaterial3: true, // Enables Material 3 design
      ),
      // Determines the initial page based on authentication state
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? Homepage() // Navigate to Homepage if user is logged in and email is verified
          : Login(), // Otherwise, navigate to Login page
      routes: {
        "signup": (context) => const SignUp(), // Route to Signup page
        "login": (context) => const Login(), // Route to Login page
        "homepage": (context) =>  Homepage(), // Route to Homepage
      },
    );
  }
}

/// Custom widget representing a stateful home page
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title; // Title property for the home page

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// State class for MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; // A counter for demonstration purposes

  @override
  void initState() {
    super.initState();

    // Listens for authentication state changes (user login/logout)
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  /// Function to increment the counter
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  /// Function to add a user to Firestore
  void addUser(String userId, String name, String email) {
    FirebaseFirestore.instance.collection('users').doc(userId).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(), // Records creation timestamp
    }).then((_) {
      print("User added successfully!"); // Success message
    }).catchError((error) {
      print("Failed to add user: $error"); // Error handling
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // A column to center the button on the screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              // Button to add a user to Firestore
              onPressed: () {
                addUser('Salwa01', 'Salwa Alhariri', 'salwa@example.com');
              },
              child: const Text('Add Collection'),
            )
          ],
        ),
      ),
    );
  }
}
