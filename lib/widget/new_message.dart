import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _MyNewMessage();
}

class _MyNewMessage extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  _sendMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }

    ///
     User user = FirebaseAuth.instance.currentUser!;

     //to get information about first collection of user
     late DocumentSnapshot<Map<String, dynamic>> userData;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((val){
      print(val.id);
      setState(() {
        userData=val;
      });
    });

    //to add new collection in firebase display information about chat

    CollectionReference collection = FirebaseFirestore.instance.collection('chat');
    Map<String, dynamic> uData ={
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'Email':user.email,
      'username':  userData.data()?['name'],
    };
    await collection.add(uData);   // await FirebaseFirestore.instance.collection('chat').add(
    // );

    _messageController.clear(); // after send a message
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
        child: Row(
          children: [
            Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration:
                  const InputDecoration(labelText: 'Send a message ...'),
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  enableSuggestions: true,
                )),
            IconButton(
              onPressed: () async{
                await _sendMessage();
              },
              icon: const Icon(
                Icons.send,
                color: Color.fromARGB(255, 145, 195, 236),
              ),
            ),
          ],
        ));
  }



}
