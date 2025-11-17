import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/splash_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'styles/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'AZ Education',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const SplashPage(),
      builder: (context, child) {
        // Animate page transitions globally
        return Animate(
          effects: const [FadeEffect(duration: Duration(milliseconds: 300))],
          child: child!,
        );
      },
    );
  }
}
