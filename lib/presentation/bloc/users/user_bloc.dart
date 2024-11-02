import 'package:chatting/domain/models/user.dart';
import 'package:chatting/presentation/bloc/users/user_event.dart';
import 'package:chatting/presentation/bloc/users/user_state.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('users');

  UserBloc() : super(UserInitialState()) {
    on<FetchUsersEvent>(
      (event, emit) async {
        emit(UserLoading());
        try {
          final snapshot = await _databaseReference.get();
          final data = snapshot.value as Map<dynamic, dynamic>?;

          if (data != null) {
            final users = data.entries.map((entry) {
              return User.fromMap(Map<String, dynamic>.from(entry.value));
            }).toList();
            emit(UserLoaded(users));
          } else {
            emit(UserError("No users found"));
          }
        } catch (e) {
          emit(UserError("Error fetching users: $e"));
        }
      },
    );
  }
}
