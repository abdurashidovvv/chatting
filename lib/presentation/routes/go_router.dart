import 'package:chatting/presentation/screens/add_user_data/add_user_data_screen.dart';
import 'package:chatting/presentation/screens/auth_screen/auth_screen.dart';
import 'package:chatting/presentation/screens/home_screen/home_screen.dart';
import 'package:chatting/presentation/screens/message/message_screen.dart';
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
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(
          path: "/add_user_data",
          builder: (context, state) => const AddUserDataScreen()),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/messages',
        builder: (context, state) => const MessageScreen(),
      ),
    ],
  );
}
