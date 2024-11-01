abstract class UserDataState {}

class InitialDataState extends UserDataState {}

class UserDataUploading extends UserDataState {}

class UserDataUploaded extends UserDataState {
  final String downloadUrl;
  final String firstName;
  final String lastName;

  UserDataUploaded(
      {required this.downloadUrl,
      required this.firstName,
      required this.lastName});
}

class UserDataUploadedError extends UserDataState {
  final String message;
  UserDataUploadedError({required this.message});
}
