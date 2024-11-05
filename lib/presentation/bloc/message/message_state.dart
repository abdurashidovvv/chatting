// message_state.dart
import 'package:chatting/domain/models/message.dart';

abstract class MessageState {}

class MessageInitialState extends MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<Message> messages;

  MessageLoaded(this.messages);
}

class MessageError extends MessageState {
  final String message;

  MessageError(this.message);
}

class MessageSent extends MessageState {}
