import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/course_model.dart';
import '../../providers/course_provider.dart';

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
      appBar: AppBar(title: const Text("Courses")),
      body: coursesAsync.when(
        data: (courses) {
          debugPrint("Courses fetched: ${courses.length}");
          if (courses.isEmpty) return const Center(child: Text("No courses added yet."));

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseCard(course: course);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text("Error loading courses:\n$err", style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final CourseModel course;
  const CourseCard({super.key, required this.course});

  // Default image URL
  static const defaultImageUrl =
      "https://ubpiwzohjbeyagmnkvfx.supabase.co/storage/v1/object/public/test-courses/default_course.png";

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Image.network(
              course.imageUrl ?? defaultImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // fallback if the URL fails
                return Image.network(defaultImageUrl, fit: BoxFit.cover);
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(course.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          if (course.duration != null)
            Text("Duration: ${course.duration}", style: const TextStyle(fontSize: 16)),
          if (course.fees != null)
            Text("Fees: \$${course.fees}", style: const TextStyle(fontSize: 16)),
        ]),
      ),
    );
  }
}

