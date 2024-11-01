import 'package:chatting/presentation/bloc/user_data/user_data_event.dart';
import 'package:chatting/presentation/bloc/user_data/user_data_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  UserDataBloc() : super(UserDataInitial()) {
    on<SaveUserDataEvent>((event, emit) async {
      emit(UserDataSaving());
      await saveUserData(event, emit);
    });
  }

  Future<void> saveUserData(
      SaveUserDataEvent event, Emitter<UserDataState> emit) async {
    try {
      // Firebase Authentication dan currentUserni olish
      String userUID = FirebaseAuth.instance.currentUser!.uid;

      // Foydalanuvchi ma'lumotlarini saqlash
      await _databaseReference.child("users/$userUID").set({
        "user_uid": event.userUID,
        "firstName": event.firstName,
        "lastName": event.lastName,
      });

      emit(UserDataSaved());
    } catch (e) {
      emit(UserDataError("Xatolik: $e"));
    }
  }
}
