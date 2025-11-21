import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:azeducation/models/user_model.dart';
import 'package:azeducation/features/universities_tier/show/detailed_page.dart';
import 'package:azeducation/providers/user_provider.dart';
import 'package:azeducation/features/universities_tier/university_provider.dart';

final dataProvider = ChangeNotifierProvider((ref) => DataProvider());

class StudentHome extends ConsumerStatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  ConsumerState<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends ConsumerState<StudentHome> {
  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProfileProvider);
    final provider = ref.watch(dataProvider);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) =>
          Scaffold(body: Center(child: Text('Error loading user: $e'))),
      data: (user) {
        if (user == null || !user.isStudent) {
          return const Scaffold(
            body: Center(child: Text("No student profile found.")),
          );
        }

        List<String> courses = [];
        if (user is Student) {
          courses = user.courses;
        } else if (user.toMap().containsKey('courses')) {
          courses = List<String>.from(user.toMap()['courses'] ?? []);
        }

        if (courses.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text("No course selected. Please contact admin."),
            ),
          );
        }

        final courseId = courses.first;
        Course? course = provider.courses.firstWhere(
          (c) => c.courseId == courseId,
          orElse: () => Course(
            courseId: '',
            universityId: '',
            courseName: '',
            createdAt: DateTime.fromMillisecondsSinceEpoch(0),
          ),
        );
        if (course.courseId == '') {
          return const Scaffold(body: Center(child: Text("Course not found.")));
        }

        final subjects = provider.subjects
            .where((s) => s.courseId == courseId)
            .toList();
        final details = provider.courseDetails
            .where((d) => d.courseId == courseId)
            .toList();

        // Only navigate once
        if (!_navigated) {
          _navigated = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => CombinedCourseDetailPage(
                  course: course,
                  subjects: subjects,
                  courseDetails: details,
                ),
              ),
            );
          });
        }

        return const Scaffold(
          body: Center(child: Text('Redirecting to your course...')),
        );
      },
    );
  }
}
