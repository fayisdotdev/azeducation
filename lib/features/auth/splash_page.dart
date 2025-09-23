import 'dart:async';
import 'package:azeducation/features/home/home_page.dart';
import 'package:azeducation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'login_page.dart';
import 'package:azeducation/features/courses/list_courses.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Always show splash for at least 3 seconds
    Timer(const Duration(seconds: 2), _navigateNext);
  }

  void _navigateNext() {
    final currentUser = ref.read(currentUserProvider);

    if (mounted) {
      if (currentUser != null) {
        // ✅ User is logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        // ✅ User is not logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CourseListPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "AZ Education",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
