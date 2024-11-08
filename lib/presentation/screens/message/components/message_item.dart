import 'package:chatting/domain/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/message/message_bloc.dart';
import '../../../bloc/message/message_event.dart';

class MessageItem extends StatelessWidget {
  final Message message;

  const MessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isCurrentUser = message.senderId == FirebaseAuth.instance.currentUser?.uid;

    return GestureDetector(
      onLongPress: () {
        _showContextMenu(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: isCurrentUser ? const Color(0xFF771C98) : Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isCurrentUser ? const Radius.circular(12) : Radius.zero,
              bottomRight: isCurrentUser ? Radius.zero : const Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.message,
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : Colors.black,
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                formatTimestamp(message.timestamp),
                style: TextStyle(
                  color: isCurrentUser ? Colors.white70 : Colors.black54,
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("Message Options"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: message.message));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Message copied to clipboard")),
                );
              },
              child: const Text("Copy Message"),
            ),
            SimpleDialogOption(
              onPressed: () {
                // Delete message logic here
                context.read<MessageBloc>().add(
                  DeleteMessageEvent(
                    currentUserId: message.senderId,
                    receiverUserId: message.receiverId,
                    messageId: message.messageId,
                  ),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Message deleted")),
                );
              },
              child: const Text("Delete Message"),
            ),
          ],
        );
      },
    );
  }

  String formatTimestamp(String timestamp) {
    try {
      final intTimestamp = int.tryParse(timestamp);
      if (intTimestamp != null) {
        final date = DateTime.fromMillisecondsSinceEpoch(intTimestamp);
        return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
      } else {
        final date = DateTime.parse(timestamp);
        return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
      }
    } catch (e) {
      print("Error parsing timestamp: $e");
      return "Invalid date";
    }
  }
}
