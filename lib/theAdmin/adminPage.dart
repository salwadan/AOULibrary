import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salwa_app/auth/login.dart';
import 'package:salwa_app/theAdmin/addDataPage.dart';
import 'package:salwa_app/theAdmin/deletePage.dart';
import 'package:salwa_app/theAdmin/modifyPage.dart';
import 'package:salwa_app/homepage.dart';

// Represents the main admin page with various navigation options for admin actions.
class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar section
      appBar: AppBar(
        title: const Text("Admin Page"),
        backgroundColor: const Color.fromARGB(255, 155, 182, 229),
        actions: [
          IconButton(
            // Logout button in the AppBar
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => Login()));
            },
            tooltip: "Logout",
          ),
        ],
      ),

      // Main body of the admin page
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Admin page",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            // add data page button
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 155, 182, 229),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddDataPage()),
                );
              },
              child: const Text("Add Data"),
            ),

            // modify data page button
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 155, 182, 229),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ModifyPage()),
                );
              },
              child: const Text("Modify Data"),
            ),

            // delete data page button
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 155, 182, 229),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const DeletePage()),
                );
              },
              child: const Text("Delete Data"),
            ),

            // home page button
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 155, 182, 229),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Homepage()),
                );
              },
              child: const Text("Go to Home Page"),
            ),
          ],
        ),
      ),
    );
  }
}
