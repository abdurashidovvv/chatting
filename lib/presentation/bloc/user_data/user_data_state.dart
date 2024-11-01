abstract class UserDataState {}

class UserDataInitial extends UserDataState {}

class UserDataSaving extends UserDataState {}

class UserDataSaved extends UserDataState {}

class UserDataError extends UserDataState {
  final String message;
  UserDataError(this.message);
}
