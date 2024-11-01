import 'package:chatting/presentation/bloc/user_data/user_data_event.dart';
import 'package:chatting/presentation/bloc/user_data/user_data_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserDataBloc() : super(UserDataInitial());

  @override
  Stream<UserDataState> mapEventToState(UserDataEvent event) async* {
    if (event is SaveUserDataEvent) {
      yield UserDataSaving();
      try {
        String userUID = _auth.currentUser?.uid ?? "";
        await _databaseReference.child("users/$userUID").set({
          "uid": event.userUID,
          "firstName": event.firstName,
          "lastName": event.lastName,
        });
        yield UserDataSaved();
      } catch (e) {
        yield UserDataError("Xatolik: $e");
      }
    }
  }
}
