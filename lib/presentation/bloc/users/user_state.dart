import 'package:chatting/domain/models/user.dart';

abstract class UserState {}

class UserInitialState extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  UserLoaded(this.users);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
