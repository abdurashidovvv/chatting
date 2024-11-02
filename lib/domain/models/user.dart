class User {
  final String uid;
  final String firstName;
  final String lastName;

  User({required this.uid, required this.firstName, required this.lastName});

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      uid: data['user_uid'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_uid': uid,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
