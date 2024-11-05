import 'package:chatting/domain/models/message.dart';
import 'package:chatting/domain/models/user.dart' as AppUser;
import 'package:chatting/presentation/bloc/message/message_bloc.dart';
import 'package:chatting/presentation/bloc/message/message_event.dart';
import 'package:chatting/presentation/bloc/message/message_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MessageScreen extends StatefulWidget {
  final AppUser.User user;
  const MessageScreen({super.key, required this.user});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleKeyboardClose);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    BlocProvider.of<MessageBloc>(context).add(
      FetchMessagesEvent(
        currentUserId: FirebaseAuth.instance.currentUser!.uid,
        receiverUserId: widget.user.uid,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyboardClose() {
    if (!_focusNode.hasFocus) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String formatTimestamp(String timestamp) {
    try {
      final intTimestamp = int.tryParse(timestamp);
      if (intTimestamp != null) {
        final date = DateTime.fromMillisecondsSinceEpoch(intTimestamp);
        return "${date.hour}:${date.minute}"; // Format as desired
      } else {
        final date = DateTime.parse(timestamp);
        return "${date.hour}:${date.minute}"; // Format as desired
      }
    } catch (e) {
      print("Error parsing timestamp: $e");
      return "Invalid date";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.firstName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  if (state is MessageLoaded) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        return ListTile(
                          title: Text(message.message, style: const TextStyle(color: Colors.black)),
                          subtitle: Text(formatTimestamp(message.timestamp)),
                        );
                      },
                    );
                  } else if (state is MessageError) {
                    return const Center(child: Text("Something went wrong"));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<MessageBloc>(context).add(
                      SendMessageEvent(
                        receiverUserUid: widget.user.uid,
                        message: Message(
                            message: _messageController.text,
                            timestamp: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            senderId: FirebaseAuth.instance.currentUser!.uid,
                            receiverId: widget.user.uid),
                      ),
                    );
                    _messageController.clear();
                    _scrollToBottom(); // Scroll to bottom after sending message
                  },
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Color(0xFF771F98),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
