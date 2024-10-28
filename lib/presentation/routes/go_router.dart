import 'package:chatting/presentation/screens/home_screen/home_screen.dart';
import 'package:chatting/presentation/screens/onboarding_screen/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter router(String initialRoute) {
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
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
}
