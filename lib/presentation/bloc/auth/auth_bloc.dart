import 'package:chatting/data/remote/auth_service.dart';
import 'package:chatting/presentation/bloc/auth/auth_event.dart';
import 'package:chatting/presentation/bloc/auth/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequest);
    on<EmailSignInRequested>(_onEmailSignInRequest);
  }

  Future<void> _onGoogleSignInRequest(
      GoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      User? user = await _authService.signInWithGoogle();
      if (user != null) {
        emit(Authenticated(user.email!));
      } else {
        emit(AuthError("Google bilan kirishda xatolik"));
      }
    } catch (e) {
      emit(AuthError("Xatolik: $e"));
    }
  }

  Future<void> _onEmailSignInRequest(
      EmailSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      User? user = await _authService.signInWithEmailPassword(
          event.email, event.password);
      if (user != null) {
        emit(Authenticated(user.email!));
      } else {
        emit(AuthError("Email bilan kirishda xatolik"));
      }
    } catch (e) {
      emit(AuthError("Xatolik: $e"));
    }
  }
}
