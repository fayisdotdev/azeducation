import 'package:azeducation/features/universities_tier/add/add_courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/auth/login_page.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:azeducation/features/universities_tier/show/detailed_page.dart';

class UniversityCourseSubjectListPage extends ConsumerStatefulWidget {
  const UniversityCourseSubjectListPage({super.key});

  @override
  ConsumerState<UniversityCourseSubjectListPage> createState() =>
      _UniversityCourseSubjectListPageState();
}

class _UniversityCourseSubjectListPageState
    extends ConsumerState<UniversityCourseSubjectListPage> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Universities & Courses"),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: "Login",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: provider.universities.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final university = provider.universities[index];

            final coursesForUni = provider.courses
                .where((c) => c.universityId == university.universityId)
                .toList();

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CoursesGridPage(
                      title: university.universityName,
                      courses: coursesForUni,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.school, size: 40, color: Colors.orange),
                        const SizedBox(height: 8),
                        Text(
                          university.universityName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text("${coursesForUni.length} courses"),
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

                  final subjects = provider.subjects
                      .where((s) => s.courseId == course.courseId)
                      .toList();

                  final courseDetails = provider.courseDetails
                      .where((d) =>
                          d.courseId == course.courseId && d.subjectId == null)
                      .toList();

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CombinedCourseDetailPage(
                              course: course,
                              subjects: subjects,
                              courseDetail: courseDetails.isNotEmpty
                                  ? courseDetails.first
                                  : null,
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
                              const Icon(Icons.school_outlined,
                                  size: 36, color: Colors.green),
                              const SizedBox(height: 8),
                              Text(course.courseName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                subjects.isEmpty
                                    ? "No subjects"
                                    : "${subjects.length} subjects",
                                style: const TextStyle(fontSize: 12),
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
