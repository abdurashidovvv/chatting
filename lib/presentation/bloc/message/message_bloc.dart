import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/models/message.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('messages');

  late final StreamSubscription<DatabaseEvent> _messagesSubscription;

  MessageBloc() : super(MessageInitialState()) {
    on<FetchMessagesEvent>((event, emit) {
      _initializeMessagesListener(event.currentUserId, event.receiverUserId);
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        await _databaseReference
            .child(
                '${event.message.senderId}/${event.message.receiverId}/${event.message.messageId}')
            .set(event.message.toMap());
      } catch (e) {
        emit(MessageError("Error sending message: $e"));
      }
    });

    on<DeleteMessageEvent>(
      (event, emit) async {
        try {
          emit(MessageLoading());
          await _databaseReference
              .child(
                  '${event.currentUserId}/${event.receiverUserId}/${event.messageId}')
              .remove();

          add(FetchMessagesEvent(
            currentUserId: event.currentUserId,
            receiverUserId: event.receiverUserId,
          ));
        } catch (e) {
          emit(MessageError("Error deleting message: $e"));
        }
      },
    );
  }
  late final StreamSubscription<DatabaseEvent> _senderSubscription;
  late final StreamSubscription<DatabaseEvent> _receiverSubscription;

  void _initializeMessagesListener(String senderId, String receiverId) {
    final senderToReceiverPath = 'messages/$senderId/$receiverId';
    final receiverToSenderPath = 'messages/$receiverId/$senderId';

    final senderReference = FirebaseDatabase.instance.ref().child(senderToReceiverPath);
    final receiverReference = FirebaseDatabase.instance.ref().child(receiverToSenderPath);

    // Listen to sender-to-receiver messages
    _senderSubscription = senderReference.onValue.listen((DatabaseEvent event) {
      _handleNewMessages(event);
    });

    // Listen to receiver-to-sender messages
    _receiverSubscription = receiverReference.onValue.listen((DatabaseEvent event) {
      _handleNewMessages(event);
    });
  }

  void _handleNewMessages(DatabaseEvent event) {
    final snapshot = event.snapshot;

    if (snapshot.exists && snapshot.value != null) {
      final data = (snapshot.value as Map<dynamic, dynamic>)
          .map((key, value) => MapEntry(key.toString(), value));

      // Convert the snapshot data to a list of messages
      List<Message> newMessages = data.entries.map((entry) {
        final messageMap = Map<String, dynamic>.from(entry.value);
        return Message.fromMap(messageMap);
      }).toList();

      // Get the current state and merge new messages with existing ones
      List<Message> allMessages = [];
      if (state is MessageLoaded) {
        allMessages = List.from((state as MessageLoaded).messages);
      }

      allMessages.addAll(newMessages);

      // Remove duplicate messages based on messageId and sort by timestamp
      final uniqueMessages = {for (var msg in allMessages) msg.messageId: msg}.values.toList();
      uniqueMessages.sort((a, b) => int.parse(a.timestamp).compareTo(int.parse(b.timestamp)));

      // Emit the updated list of messages
      emit(MessageLoaded(uniqueMessages));
    } else {
      emit(MessageError("No messages found"));
    }
  }

  @override
  Future<void> close() {
    // Cancel both subscriptions
    _senderSubscription.cancel();
    _receiverSubscription.cancel();
    return super.close();
  }

}
