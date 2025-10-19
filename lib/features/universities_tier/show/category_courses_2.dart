import 'package:azeducation/features/universities_tier/add/add_courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:azeducation/features/universities_tier/show/detailed_page.dart';

class CategoryCoursesPage extends ConsumerWidget {
  final String categoryId;

  const CategoryCoursesPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(dataProvider);

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Filter courses for this category
    final courses = provider.courses
        .where((c) => c.categoryId == categoryId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses in Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: courses.isEmpty
            ? const Center(child: Text("No courses found in this category."))
            : GridView.builder(
                itemCount: courses.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final course = courses[index];

                  // Null-safe way to get the course detail
                  final courseDetailsList = provider.courseDetails
                      .where((d) =>
                          d.courseId == course.courseId && d.subjectId == null)
                      .toList();

                  final CourseDetail? courseDetail = courseDetailsList.isNotEmpty
                      ? courseDetailsList.first
                      : null;

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (courseDetail != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CourseDetailPage(detail: courseDetail),
                            ),
                          );
                        }
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.school_outlined,
                                size: 36,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                course.courseName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                courseDetail == null
                                    ? "No details"
                                    : "Details available",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
