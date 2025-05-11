import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/onboarding/permission_request_screen.dart';
import 'features/home/home_screen.dart';
import 'features/detail/detail_screen.dart';
import 'features/settings/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/permission',
      builder: (context, state) => const PermissionRequestScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            final List<String> summaryList = (data['summaryList'] as List).map((e) => e.toString()).toList();
            return DetailScreen(
              ticker: data['ticker'],
              logoUrl: data['logoUrl'],
              sentiment: data['sentiment'],
              sentimentEmoji: data['sentimentEmoji'],
              price: data['price'],
              change: data['change'],
              summaryList: summaryList,
  );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'today-meme-news',
      routerConfig: _router,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B1B2B),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B1B2B),
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
