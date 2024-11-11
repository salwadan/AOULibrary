import 'package:flutter/material.dart';
import 'package:salwa_app/widget/chat_Message.dart';
import 'package:salwa_app/widget/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AOULibrary Chat ')),
      body: const Column(
        children: [
          Expanded(child: ChatMessage()),
          NewMessage(),
        ],
      ),
    );
  }
}
