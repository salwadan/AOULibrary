import 'package:flutter/material.dart';
import 'package:salwa_app/components/custombuttonauth.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // Function to show the password change dialog
  void _showPasswordChangeDialog() {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Change Password"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Current Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text ==
                    confirmPasswordController.text) {
                  // Handle password change logic here
                  print("Current Password: ${currentPasswordController.text}");
                  print("Password changed to: ${newPasswordController.text}");
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // Show error message if passwords do not match
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Passwords do not match")),
                  );
                }
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Information"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        color: const Color.fromARGB(255, 214, 213, 213),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            SizedBox(width: 10),
            Text(
              '   Name :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 15),
            EditTextfield(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            SizedBox(width: 10),
            Text(
              '   Password :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 15),
            CustomButtonAuth(
              title: "Change Password",
              buttonColor: const Color.fromARGB(255, 56, 101, 217),
              onPressed: _showPasswordChangeDialog, // Show dialog when pressed
              width: double.infinity,
            ),

            SizedBox(height: 15),
            CustomButtonAuth(
              title: "Submit",
              buttonColor: const Color.fromRGBO(4, 6, 93, 1),
              onPressed: _showPasswordChangeDialog, // Show dialog when pressed
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

class EditTextfield extends StatelessWidget {
  const EditTextfield({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 86, 86, 86)),
        ),
      ),
    );
  }
}
