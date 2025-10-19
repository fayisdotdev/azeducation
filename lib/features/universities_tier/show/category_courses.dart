import 'package:azeducation/features/universities_tier/add/add_courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:azeducation/features/universities_tier/show/detailed_page.dart';

class CoursesByCategoryPage extends ConsumerStatefulWidget {
  const CoursesByCategoryPage({super.key});

  @override
  ConsumerState<CoursesByCategoryPage> createState() =>
      _CoursesByCategoryPageState();
}

class _CoursesByCategoryPageState extends ConsumerState<CoursesByCategoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dataProvider).fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dataProvider);

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Group courses by category
    final Map<String, List<Course>> groupedCourses = {};
    for (var course in provider.courses) {
      final categoryId = course.categoryId ?? 'uncategorized';
      groupedCourses.putIfAbsent(categoryId, () => []).add(course);
    }

    String getCategoryName(String id) {
      if (id == 'uncategorized') return 'Uncategorized';
      return provider.categories
              .firstWhere(
                (c) => c.categoryId == id,
                orElse: () => CourseCategory(
                  categoryId: id,
                  categoryName: 'Unknown',
                  createdAt: DateTime.now(),
                ),
              )
              .categoryName;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Courses by Categories")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: groupedCourses.keys.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final categoryId = groupedCourses.keys.elementAt(index);
            final categoryName = getCategoryName(categoryId);
            final courses = groupedCourses[categoryId]!;

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CoursesGridPage(
                        title: categoryName,
                        courses: courses,
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.category_outlined,
                            size: 40, color: Colors.blue),
                        const SizedBox(height: 8),
                        Text(categoryName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("${courses.length} courses"),
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

// Grid page to show courses for a category/university
class CoursesGridPage extends ConsumerWidget {
  final String title;
  final List<Course> courses;
  const CoursesGridPage({super.key, required this.title, required this.courses});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: courses.isEmpty
            ? const Center(child: Text("No courses found."))
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
                  // Subjects for this course
                  final subjects = provider.subjects
                      .where((s) => s.courseId == course.courseId)
                      .toList();

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () {
                        if (subjects.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SubjectsGridPage(
                                title: course.courseName,
                                subjects: subjects,
                              ),
                            ),
                          );
                        } else {
                          // Show course details directly if no subjects
                          final courseDetailsList = provider.courseDetails
                              .where((d) =>
                                  d.courseId == course.courseId &&
                                  d.subjectId == null)
                              .toList();

                          if (courseDetailsList.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailPage(
                                    detail: courseDetailsList.first),
                              ),
                            );
                          }
                        }
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.school_outlined,
                                  size: 36, color: Colors.green),
                              const SizedBox(height: 8),
                              Text(course.courseName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text("${subjects.length} subjects"),
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

// Grid page for subjects
class SubjectsGridPage extends ConsumerWidget {
  final String title;
  final List<Subject> subjects;
  const SubjectsGridPage({super.key, required this.title, required this.subjects});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: subjects.isEmpty
            ? const Center(child: Text("No subjects found."))
            : GridView.builder(
                itemCount: subjects.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  final details = provider.courseDetails
                      .where((d) => d.subjectId == subject.subjectId)
                      .toList();

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () {
                        if (details.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CourseDetailPage(detail: details.first),
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
                              const Icon(Icons.subject, size: 36, color: Colors.orange),
                              const SizedBox(height: 8),
                              Text(subject.subjectName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(details.isEmpty ? "No details" : "Details available",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
