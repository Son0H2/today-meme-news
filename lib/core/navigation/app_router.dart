import 'package:flutter/material.dart';
import 'package:today_meme_news/features/splash/splash_screen.dart';
import 'package:today_meme_news/features/onboarding/onboarding_screen.dart';
// import 'package:today_meme_news/features/home/home_screen.dart';
// import 'package:today_meme_news/features/settings/settings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case '/onboarding':
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

// 임시 위젯들은 main.dart에 정의되어 있으므로 이 파일에서는 삭제 