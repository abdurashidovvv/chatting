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
          emit(MessageDeleted());
        } catch (e) {
          emit(MessageError("Error deleting message: $e"));
        }
      },
    );
  }

  void _initializeMessagesListener(String senderId, String receiverId) {
    final path = 'messages/$senderId/$receiverId';
    final reference = FirebaseDatabase.instance.ref().child(path);

    _messagesSubscription = reference.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value != null) {
        final data = (snapshot.value as Map<dynamic, dynamic>)
            .map((key, value) => MapEntry(key.toString(), value));

        List<Message> messages = [];
        data.forEach((messageId, messageContent) {
          final messageMap = Map<String, dynamic>.from(messageContent);
          messages.add(Message.fromMap(messageMap));
        });

        messages.sort(
            (a, b) => int.parse(a.timestamp).compareTo(int.parse(b.timestamp)));
        emit(MessageLoaded(messages));
      } else {
        emit(MessageError("No messages found"));
      }
    });
  }

  @override
  Future<void> close() {
    _messagesSubscription.cancel();
    return super.close();
  }
}
