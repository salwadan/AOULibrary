import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/Setting/account.dart';

import '../auth/login.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  // List of setting names and icons
  List<String> settingName = ["Account Information", "Log Out"];
  List<Icon> settingIcon = [Icon(Icons.person), Icon(Icons.logout)];

  // LogOut function
  void logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      body: ListView.builder(
        itemCount: settingName.length,
        itemBuilder: (context, index) {
          return Container(
            height: screenHeight / 8,
            width: screenWidth * 0.8,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromARGB(66, 255, 255, 255), width: 3),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 1,
                  blurRadius: 6,
                ),
              ],
            ),
            child: Center(
              child: ListTile(
                title: Text(settingName[index]),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                  size: 30,
                ),
                leading: settingIcon[index],
                onTap: () {
                  if (index == 0) {
                    // Navigate to Account Information screen
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Account()),
                    );
                  } else if (index == 1) {
                    // Log out the user
                    logOut(context);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
