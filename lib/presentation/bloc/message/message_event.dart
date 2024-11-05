import 'package:chatting/domain/models/message.dart';

abstract class MessageEvent {}

class SendMessageEvent extends MessageEvent {
  final String receiverUserUid;
  final Message message;

  SendMessageEvent({required this.receiverUserUid, required this.message});
}

class FetchMessagesEvent extends MessageEvent {
  final String currentUserId;
  final String receiverUserId;

  FetchMessagesEvent(
      {required this.currentUserId, required this.receiverUserId});
}
