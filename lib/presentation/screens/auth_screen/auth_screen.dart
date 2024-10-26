import 'package:chatting/data/remote/auth_service.dart';
import 'package:chatting/presentation/bloc/auth/auth_bloc.dart';
import 'package:chatting/presentation/bloc/auth/auth_event.dart';
import 'package:chatting/presentation/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthService()),
      child:  Scaffold(
        appBar: AppBar(title: Text('Auth Screen')),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Xush kelibsiz: ${state.email}")),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Xatolik: ${state.message}")),
              );
            }
          },
          child: Center(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return CircularProgressIndicator();
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(GoogleSignInRequested());
                      },
                      child: Text('Google bilan kirish'),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Parol'),
                      obscureText: true,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();
                        BlocProvider.of<AuthBloc>(context).add(
                          EmailSignInRequested(email: email, password: password),
                        );
                      },
                      child: Text('Email bilan kirish'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
