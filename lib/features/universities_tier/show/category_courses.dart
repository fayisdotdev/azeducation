import 'package:azeducation/features/universities_tier/add/add_courses.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoursesByCategoryPage extends ConsumerStatefulWidget {
  const CoursesByCategoryPage({super.key});

  @override
  ConsumerState<CoursesByCategoryPage> createState() => _CoursesByCategoryPageState();
}

class _CoursesByCategoryPageState extends ConsumerState<CoursesByCategoryPage> {
  final Map<String, bool> _expanded = {}; // track which category is open

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

    // Helper to find category name
    String getCategoryName(String id) {
      if (id == 'uncategorized') return 'Uncategorized';
      return provider.categories
              .firstWhere((c) => c.categoryId == id, orElse: () => CourseCategory(
                    categoryId: id,
                    categoryName: 'Unknown',
                    createdAt: DateTime.now(),
                  ))
              .categoryName;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses by Categories"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "By Categories",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Build category sections
            ...groupedCourses.entries.map((entry) {
              final categoryId = entry.key;
              final categoryName = getCategoryName(categoryId);
              final courses = entry.value;
              final isExpanded = _expanded[categoryId] ?? false;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  title: Text(
                    "$categoryName (${courses.length})",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  initiallyExpanded: isExpanded,
                  onExpansionChanged: (val) {
                    setState(() {
                      _expanded[categoryId] = val;
                    });
                  },
                  children: courses
                      .map(
                        (course) => ListTile(
                          title: Text(course.courseName),
                          subtitle: Text(
                            provider.universities
                                .firstWhere(
                                  (u) => u.universityId == course.universityId,
                                  orElse: () => University(
                                    universityId: '',
                                    universityName: 'Unknown University',
                                    createdAt: DateTime.now(),
                                  ),
                                )
                                .universityName,
                          ),
                          leading: const Icon(Icons.school_outlined),
                        ),
                      )
                      .toList(),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
