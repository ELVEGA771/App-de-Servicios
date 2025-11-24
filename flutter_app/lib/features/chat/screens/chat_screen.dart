import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final int conversacionId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.conversacionId,
    required this.otherUserName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(otherUserName)),
      body: const Center(child: Text('Chat')),
    );
  }
}
