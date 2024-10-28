import 'package:chatting/presentation/routes/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final user = await FirebaseAuth.instance.authStateChanges().first;
  final initialRoute = user != null ? '/home' : '/onboarding';
  runApp(MyApp(direction: initialRoute));
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
