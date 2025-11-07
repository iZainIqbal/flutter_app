import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/screen_a.dart';
import 'screens/screen_b.dart';
import 'screens/screen_c.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'a',
      builder: (context, state) => ScreenA(
        congrats: (state.extra as Map<String, dynamic>?)?['congrats'] == true,
      ),
    ),
    GoRoute(
      path: '/b',
      name: 'b',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ScreenB(
          phrase: extra != null ? (extra['phrase'] as String?) : null,
          hashtags: extra != null ? (extra['hashtags'] as List<String>?) : null,
        );
      },
    ),
    GoRoute(
      path: '/c',
      name: 'c',
      builder: (context, state) => const ScreenC(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.teal);
    return MaterialApp.router(
      title: 'Navigation & Hashtags Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorScheme.surface.withOpacity(0.06),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
