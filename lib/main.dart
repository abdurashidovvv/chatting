import 'package:chatting/data/remote/auth_service.dart';
import 'package:chatting/presentation/bloc/auth/auth_bloc.dart';
import 'package:chatting/presentation/routes/go_router.dart';
import 'package:chatting/presentation/screens/auth_screen/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final user = await FirebaseAuth.instance.authStateChanges().first;
  final initialRoute = user != null ? '/home' : '/onboarding';
  runApp(BlocProvider(
    create: (context) => AuthBloc(AuthService()),
    child: MyApp(direction: initialRoute),
  ));
}

class MyApp extends StatelessWidget {
  final String direction;
  const MyApp({super.key, required this.direction});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router(direction),
    );
  }
}
