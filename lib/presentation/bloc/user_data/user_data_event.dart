import 'dart:io';

abstract class UserDataEvent {}

abstract class UploadImage extends UserDataEvent {
  final File image;
  UploadImage(this.image);
}

class SaveUserDataEvent extends UserDataEvent {
  final String firstName;
  final String lastName;
  final String downloadUrl;

  SaveUserDataEvent(this.firstName, this.lastName, this.downloadUrl);
}
