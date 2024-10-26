abstract class AuthEvent {}

class GoogleSignInRequested extends AuthEvent {}

class EmailSignInRequested extends AuthEvent {
  final String email;
  final String password;

  EmailSignInRequested({required this.email, required this.password});
}

