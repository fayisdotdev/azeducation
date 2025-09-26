import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/providers/course_provider.dart';
import 'package:azeducation/widgets/course_card.dart';

class AllCoursesPage extends ConsumerWidget {
  const AllCoursesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(courseListProvider);

    return coursesAsync.when(
      data: (courses) => courses.isEmpty
          ? const Center(child: Text("No courses added yet."))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.88,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return CourseCard(course: courses[index]);
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Text("Error loading courses:\n$err",
            style: const TextStyle(color: Colors.red)),
      ),
    );
  }
}
