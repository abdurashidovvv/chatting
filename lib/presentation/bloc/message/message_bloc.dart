import 'package:chatting/domain/models/message.dart';
import 'package:chatting/presentation/bloc/message/message_event.dart';
import 'package:chatting/presentation/bloc/message/message_state.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('messages');

  MessageBloc() : super(MessageInitialState()) {
    on<FetchMessagesEvent>((event, emit) async {
      emit(MessageLoading());
      try {
        final snapshot = await _databaseReference
            .child('${event.currentUserId}/${event.receiverUserId}')
            .get();

        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          final messages = data.entries
              .map((entry) => Message.fromMap(entry.value))
              .toList();
          emit(MessageLoaded(messages));
        } else {
          emit(MessageError("No messages found"));
        }
      } catch (e) {
        emit(MessageError("Error fetching messages: $e"));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        String messageId = DateTime.now().millisecondsSinceEpoch.toString();

        await _databaseReference
            .child(
                '${event.message.senderId}/${event.message.receiverId}/$messageId')
            .set(event.message.toMap());

        emit(MessageSent());
      } catch (e) {
        emit(MessageError("Error sending message: $e"));
      }
    });
  }
}
