import 'package:chatting/presentation/screens/home_screen/home_screen.dart';
import 'package:chatting/presentation/screens/onboarding_screen/onboarding_screen.dart';
import 'package:chatting/presentation/screens/onboarding_screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final user = _auth.currentUser;
    final loggingIn = state.matchedLocation == '/onboarding';

    if (user == null && !loggingIn) return '/onboarding';

    if (user != null && loggingIn) return '/home';

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
