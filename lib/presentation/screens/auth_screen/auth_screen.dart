import 'package:chatting/data/remote/auth_service.dart';
import 'package:chatting/presentation/bloc/auth/auth_bloc.dart';
import 'package:chatting/presentation/bloc/auth/auth_event.dart';
import 'package:chatting/presentation/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(AuthService()), child: Column());
  }
}
