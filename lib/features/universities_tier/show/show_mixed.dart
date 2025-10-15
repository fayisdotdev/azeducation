import 'package:azeducation/features/auth/login_page.dart';
import 'package:azeducation/features/universities_tier/add/add_university.dart';
import 'package:azeducation/features/universities_tier/show/category_courses.dart';
import 'package:azeducation/features/universities_tier/show/detailed_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              // icon: const Icon(Icons.add),
              child: const Text('View By Category'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CoursesByCategoryPage(),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.universities.length,
              itemBuilder: (context, uniIndex) {
                final university = provider.universities[uniIndex];

                final coursesForUni = provider.courses
                    .where((c) => c.universityId == university.universityId)
                    .toList();

                return ExpansionTile(
                  title: Text(university.universityName),
                  subtitle: Text("Courses: ${coursesForUni.length}"),
                  children: coursesForUni.map((course) {
                    final subjectsForCourse = provider.subjects
                        .where((s) => s.courseId == course.courseId)
                        .toList();

                    final courseDetail = provider.courseDetails
                        .where(
                          (d) =>
                              d.courseId == course.courseId &&
                              d.subjectId == null,
                        )
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: ExpansionTile(
                        title: InkWell(
                          onTap: () {
                            if (courseDetail.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CourseDetailPage(
                                    detail: courseDetail.first,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(course.courseName),
                        ),
                        subtitle: Text(
                          courseDetail.isEmpty
                              ? "No details"
                              : "Details available",
                        ),
                        children: subjectsForCourse.map((subject) {
                          final subjectDetail = provider.courseDetails
                              .where((d) => d.subjectId == subject.subjectId)
                              .toList();

                          return ListTile(
                            title: Text(subject.subjectName),
                            subtitle: Text(
                              subjectDetail.isEmpty
                                  ? "No details"
                                  : "Details available",
                            ),
                            onTap: () {
                              if (subjectDetail.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseDetailPage(
                                      detail: subjectDetail.first,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
