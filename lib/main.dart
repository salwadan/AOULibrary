import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/auth/login.dart';
import 'package:salwa_app/auth/signup.dart';
import 'package:salwa_app/dashboard.dart';
import 'package:salwa_app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salwa_app/homepage.dart';
import 'package:device_preview/device_preview.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(DevicePreview(builder: (context) =>const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          
            backgroundColor: Color.fromARGB(255, 173, 204, 230),
            titleTextStyle: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
                
            iconTheme: IconThemeData(color: Colors.blue)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? Dashboard()
          : Login(),
      routes: {
        "signup": (context) => const SignUp(),
        "login": (context) => const Login(),
        "homepage": (context) =>  Homepage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print(
            '==========================================User is currently signed out!');
      } else {
        print(
            '====================================================User is signed in!');
      }
    });
    super.initState();
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void addUser(String userId, String name, String email) {
    FirebaseFirestore.instance.collection('users').doc(userId).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    }).then((_) {
      print("User added successfully!");
    }).catchError((error) {
      print("Failed to add user: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body :Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  addUser('Salwa01', 'Salwa Alhariri', 'salwa@example.com');
                },
                child: const Text('Add Collection'))
          ],
        ),
      ),
    );
  }

}
