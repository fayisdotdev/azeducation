import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/providers/user_provider.dart';
import 'package:azeducation/features/universities_tier/show/show_mixed.dart';
import 'package:azeducation/models/user_model.dart';

/// Student home: open selected course page directly after login
class HomeStudentPage extends ConsumerWidget {
  const HomeStudentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileProvider);
    return userAsync.when(
      data: (user) {
        if (user == null || !user.isStudent) {
          return Scaffold(
            appBar: AppBar(title: const Text('Student Home')),
            body: const Center(child: Text('No course selected.')),
          );
        }
        // Only Student has courses
        final student = user as Student;
        if (student.courses.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Student Home')),
            body: const Center(child: Text('No course selected.')),
          );
        }
        // Open the selected course page directly
        // For now, just show the course list page (can be improved to auto-navigate)
        return UniversityCourseSubjectListPage();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}
