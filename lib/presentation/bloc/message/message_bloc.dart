import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/message.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref().child('messages');

  late final StreamSubscription<DatabaseEvent> _senderSubscription;
  late final StreamSubscription<DatabaseEvent> _receiverSubscription;

  List<Message> _senderMessages = [];
  List<Message> _receiverMessages = [];

  MessageBloc() : super(MessageInitialState()) {
    on<FetchMessagesEvent>((event, emit) {
      _initializeMessagesListener(event.currentUserId, event.receiverUserId);
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        await _databaseReference
            .child('${event.message.senderId}/${event.message.receiverId}/${event.message.messageId}')
            .set(event.message.toMap());
      } catch (e) {
        emit(MessageError("Error sending message: $e"));
      }
    });

    on<DeleteMessageEvent>((event, emit) async {
      try {
        emit(MessageLoading());

        await _databaseReference
            .child('${event.currentUserId}/${event.receiverUserId}/${event.messageId}')
            .remove();

        if (state is MessageLoaded) {
          _senderMessages = _senderMessages
              .where((msg) => msg.messageId != event.messageId)
              .toList();
          _receiverMessages = _receiverMessages
              .where((msg) => msg.messageId != event.messageId)
              .toList();
          _emitCombinedMessages();
        }
      } catch (e) {
        emit(MessageError("Error deleting message: $e"));
      }
    });
  }

  void _initializeMessagesListener(String senderId, String receiverId) {
    final senderToReceiverPath = 'messages/$senderId/$receiverId';
    final receiverToSenderPath = 'messages/$receiverId/$senderId';

    final senderReference = FirebaseDatabase.instance.ref().child(senderToReceiverPath);
    final receiverReference = FirebaseDatabase.instance.ref().child(receiverToSenderPath);

    _senderSubscription = senderReference.onValue.listen((event) {
      _updateSenderMessages(event);
    });

    _receiverSubscription = receiverReference.onValue.listen((event) {
      _updateReceiverMessages(event);
    });
  }

  void _updateSenderMessages(DatabaseEvent event) {
    _senderMessages = _processEventMessages(event);
    _emitCombinedMessages();
  }

  void _updateReceiverMessages(DatabaseEvent event) {
    _receiverMessages = _processEventMessages(event);
    _emitCombinedMessages();
  }

  List<Message> _processEventMessages(DatabaseEvent event) {
    final snapshot = event.snapshot;

    if (snapshot.exists && snapshot.value != null) {
      final data = (snapshot.value as Map<dynamic, dynamic>)
          .map((key, value) => MapEntry(key.toString(), value));

      return data.entries.map((entry) {
        final messageMap = Map<String, dynamic>.from(entry.value);
        return Message.fromMap(messageMap);
      }).toList();
    }
    return [];
  }

  void _emitCombinedMessages() {
    // Combine sender and receiver messages and remove duplicates
    final combinedMessages = [..._senderMessages, ..._receiverMessages];
    final uniqueMessages = {for (var msg in combinedMessages) msg.messageId: msg}.values.toList();
    uniqueMessages.sort((a, b) => int.parse(a.timestamp).compareTo(int.parse(b.timestamp)));

    emit(MessageLoaded(uniqueMessages));
  }

  @override
  Future<void> close() {
    _senderSubscription.cancel();
    _receiverSubscription.cancel();
    return super.close();
  }
}
