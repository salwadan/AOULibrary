import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



// class for typing and sending a new message

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _MyNewMessage();
}

class _MyNewMessage extends State<NewMessage> {
  final _messageController = TextEditingController();  // Controller for the input field

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();  // Dispose the controller when the widget is removed

  }

  // Method to send a new message
  _sendMessage() async {
    final enteredMessage = _messageController.text;  // Get the text from the input field
    if (enteredMessage.trim().isEmpty) {
      return;   // Do nothing if the message is empty
    }

    // Get the currently logged-in user's details
     User user = FirebaseAuth.instance.currentUser!;

     //to get information about first collection of user from firestore
     late DocumentSnapshot<Map<String, dynamic>> userData;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((val){
      print(val.id);
      setState(() {
        userData=val;
      });
    });

    //to add new collection in firebase display information about chat
    // Prepare the message data
    CollectionReference collection = FirebaseFirestore.instance.collection('chat');
    Map<String, dynamic> uData ={
      'text': enteredMessage,  // The message text
      'createdAt': Timestamp.now(), // Timestamp for the message
      'userId': user.uid,   // Sender's user ID
      'Email':user.email,   // Sender's email
      'username':  userData.data()?['name'],  // Sender's username
    };

    // Add the message to the Firestore collection
    await collection.add(uData);

    _messageController.clear();  // Clear the input field after sending the message
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
        child: Row(
          children: [
            // Input field for typing a message
            Expanded(
                child: TextField(
                  controller: _messageController,// Link the controller to the input field
                  decoration:
                  const InputDecoration(labelText: 'Send a message ...'),
                  autocorrect: true, // Enable autocorrect
                  textCapitalization: TextCapitalization.sentences,// Capitalize the first letter of each sentence
                  enableSuggestions: true,// Enable suggestions for typing
                )),
            // Send button
            IconButton(
              onPressed: () async{
                await _sendMessage(); // Call the send message method
              },
              icon: const Icon(
                Icons.send,
                color: Color.fromARGB(255, 145, 195, 236),// Custom color for the send icon
              ),
            ),
          ],
        ));
  }



}
