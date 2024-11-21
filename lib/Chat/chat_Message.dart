import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'message_bubble.dart';


// class to display chat messages

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!; // to find user that is uer application in current moment

    //we used StreamBuilder widget for data flow
    //Using StreamBuilder to fetch real-time chat messages from Firestore
    return StreamBuilder(

      //return stream from snapshot (data is waiting ) , return text order by data in order
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt',descending: true)//// Order messages by creation time
        .snapshots(),
      builder: (ctx, snapshot){
        // Show loading spinner while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
         //if data is null or data is empty ( data is not found )
        if (!snapshot.hasData  || snapshot.data!.docs.isEmpty ){
            return const Center(
                child: Text('No messages found'),
            );
        }

        // Handle potential errors in data fetching
        if (snapshot.hasError){
          return const Center(
            child: Text('Something went wrong ..')
          );
        }
        //get list of message

        final loadedMessage = snapshot.data!.docs;

        // Display messages in a scrollable ListView
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40, // Space at the bottom of the chat
            left:13,
            right: 13,
          ),
            reverse: true,   //to display last message form button of window
            itemCount: loadedMessage.length , // Total messages to display

            //to reach message via key text when store message under title text
            itemBuilder: (ctx,index){

            //first message - to get current message
            final chatMessage =loadedMessage[index].data();

            //next message and check if have one message to avoid errors or more message for grouping purposes
            final nextMessage =index +1 < loadedMessage.length ?
            loadedMessage[index+1].data()
                : null;


            // IDs for the current and next messages

            final currentMessageUserId =chatMessage['userId'];
            final nextMessageUserId=
            nextMessage != null? nextMessage['userId']: null;

            // Check if the next message is from the same user
            final bool nextUserIsSame = nextMessageUserId ==currentMessageUserId;
            // Return a grouped message if the user is the same
            if (nextUserIsSame){
              return MessageBubble.next(
                message: chatMessage['text'], // Text of the message
                isMe: authUser.uid==currentMessageUserId, // Check if the message is sent by the logged-in user
              );

            }
            // message becomes from another user
            else {
              // Return a standalone message bubble if it's a different user
              return MessageBubble.first(userImage: chatMessage['userImage'], // User's profile pictur
                  username: chatMessage['username'],message: chatMessage['text'],// User's name
                  isMe: authUser.uid==currentMessageUserId);  // Check if the message is from the current user


            }
            },
        );
      },
    );
  }
}