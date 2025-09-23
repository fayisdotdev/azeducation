import 'package:azeducation/providers/course_provider.dart';
import 'package:azeducation/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import your login page
import 'package:azeducation/features/auth/login_page.dart';

class CourseListPage extends ConsumerStatefulWidget {
  const CourseListPage({super.key});

  @override
  ConsumerState<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends ConsumerState<CourseListPage> {
  @override
  void initState() {
    super.initState();
    // Invalidate the provider to force fetch fresh data whenever page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(courseListProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(courseListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses"),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: "Login",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: coursesAsync.when(
        data: (courses) {
          debugPrint("Courses fetched: ${courses.length}");
          if (courses.isEmpty) {
            return const Center(child: Text("No courses added yet."));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cards per row
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1, // adjust as needed
            ),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseCard(course: course);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            "Error loading courses:\n$err",
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
