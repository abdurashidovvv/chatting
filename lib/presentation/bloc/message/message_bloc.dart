import 'dart:async';

import 'package:chatting/domain/models/message.dart';
import 'package:chatting/presentation/bloc/message/message_event.dart';
import 'package:chatting/presentation/bloc/message/message_state.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('messages');

  late final StreamSubscription<DatabaseEvent> _messagesSubscription;

  MessageBloc() : super(MessageInitialState()) {
    _initializeMessagesListener(); // Call listener initialization

    on<FetchMessagesEvent>((event, emit) {
      // We no longer need this since we are listening to updates directly
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        String messageId = DateTime.now().millisecondsSinceEpoch.toString();

        await _databaseReference
            .child(
                '${event.message.senderId}/${event.message.receiverId}/$messageId')
            .set(event.message.toMap());

        // You can choose to add logic to notify that a message has been sent,
        // but it's not necessary with the listener updating automatically.
      } catch (e) {
        emit(MessageError("Error sending message: $e"));
      }
    });
  }

  void _initializeMessagesListener() {
    _messagesSubscription =
        _databaseReference.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;
      if (snapshot.exists && snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final messages = data.entries
            .map((entry) =>
                Message.fromMap(Map<String, dynamic>.from(entry.value)))
            .toList();
        add(MessageLoaded(messages) as MessageEvent); // Emit loaded messages
      } else {
        add(MessageError("No messages found") as MessageEvent);
      }
    });
  }

  @override
  Future<void> close() {
    _messagesSubscription
        .cancel(); // Cancel the subscription when the bloc is closed
    return super.close();
  }
}
