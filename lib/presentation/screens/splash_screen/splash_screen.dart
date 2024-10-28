import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Foydalanuvchi holatini tekshirish uchun bir oz vaqt kutish
    Future.delayed(Duration(seconds: 2), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        context.go('/home'); // Foydalanuvchi kirgan bo‘lsa HomeScreen ga o‘tadi
      } else {
        context
            .go('/auth'); // Foydalanuvchi kirmagan bo‘lsa AuthScreen ga o‘tadi
      }
    });

    return Scaffold(
      backgroundColor: Colors.white, // Splash ekranning foni
      body: Center(
        child: Image.asset('assets/splash_icon.png',
            width: 100, height: 100), // Splash ekranda ikonka
      ),
    );
  }
}
