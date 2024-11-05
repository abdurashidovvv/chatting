import 'package:chatting/data/remote/auth_service.dart';
import 'package:chatting/presentation/bloc/auth/auth_bloc.dart';
import 'package:chatting/presentation/bloc/message/message_bloc.dart';
import 'package:chatting/presentation/bloc/user_data/user_data_bloc.dart';
import 'package:chatting/presentation/bloc/users/user_bloc.dart';
import 'package:chatting/presentation/routes/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final user = await FirebaseAuth.instance.authStateChanges().first;
  final initialRoute = user != null ? '/home' : '/onboarding';
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthService()),
        ),
        BlocProvider(
          create: (context) => UserDataBloc(),
        ),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(
          create: (context) => MessageBloc(),
        )
      ],
      child: MyApp(direction: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String direction;
  const MyApp({super.key, required this.direction});

  @override
  Widget build(BuildContext context) {
    // return const MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: AddUserDataScreen(),
    // );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router(direction),
    );
  }
}
