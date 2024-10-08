import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!; // to find user that is uer application in current moment
    //we used StreamBuilder widget for data flow
    return StreamBuilder(

      //return stream from snapshot (data is waiting ) , return text order by data in order
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt',descending: true).snapshots(),
      builder: (ctx, snapshot){
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
        if (snapshot.hasError){
          return const Center(
            child: Text('Something went wrong ..')
          );
        }
        //list of large data then display them

        final loadedMessage = snapshot.data!.docs;

        //display list
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left:13,
            right: 13,
          ),
            reverse: true,   //to display message form button of window to top
            itemCount: loadedMessage.length ,

            //to reach message via key text when store message under title text
            itemBuilder: (ctx,index){
            //fist message
            final chatMessage =loadedMessage[index].data();

            //next message and check if have one message to avoid errors or more message
            final nextMessage =index +1 < loadedMessage.length ?
            loadedMessage[index+1].data()
                : null;

            final currentMessageUserId =chatMessage['userId'];

            //if message is come from same user then :

            final nextMessageUserId=
            nextMessage != null? nextMessage['userId']: null;
            final bool nextUserIsSame = nextMessageUserId ==currentMessageUserId;

            if (nextUserIsSame){
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authUser.uid==currentMessageUserId,
              );

            }
            // message becomes from another user
            else {
              return MessageBubble.first(userImage: chatMessage['userImage'],
                  username: chatMessage['username'],message: chatMessage['text'],
                  isMe: authUser.uid==currentMessageUserId);
            }
            },
        );
      },
    );
  }
}