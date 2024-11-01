abstract class UserDataEvent {}

class SaveUserDataEvent extends UserDataEvent {
  final String userUID;
  final String firstName;
  final String lastName;

  SaveUserDataEvent(this.userUID, this.firstName, this.lastName);
}
