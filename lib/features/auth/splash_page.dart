import 'dart:async';
import 'package:azeducation/features/home/home_page.dart';
import 'package:azeducation/features/universities_tier/show/university_by_category.dart';
import 'package:azeducation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  StreamSubscription? _authSub;

  @override
  void initState() {
    super.initState();

    // Show splash for at least 2 seconds
    Timer(const Duration(seconds: 2), () {
      // Listen once to auth state after splash
      _authSub = ref.read(authServiceProvider).authStateChanges.listen((state) {
        final user = state.session?.user;

        if (!mounted) return;

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UniversitiesByCategoryPage()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
 @override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(Icons.school_rounded, size: 48, color: colorScheme.primary),
          ),
          const SizedBox(height: 28),
          Text(
            "AZ Education",
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: colorScheme.primary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Empowering Learning for All",
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onBackground.withOpacity(0.7)),
          ),
          const SizedBox(height: 36),
          const CircularProgressIndicator(),
        ],
      ),
    ),
  );
}
}