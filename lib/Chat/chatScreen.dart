import 'package:flutter/material.dart';
import 'chat_Message.dart';
import 'new_message.dart';


// Main Chat Screen that includes the message list and input area
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AOULibrary Chat ')),  // Title of the chat screen
      body: const Column(
        children: [
          // Expanded widget ensures the chat messages take all available space
          Expanded(child: ChatMessage()),
          // Input area for sending new messages
          NewMessage(),
        ],
      ),
    );
  }
}
