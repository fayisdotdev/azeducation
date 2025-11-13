import 'package:azeducation/features/universities_tier/add/add_courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:azeducation/features/universities_tier/show/show_mixed.dart';

class UniversitiesByCategoryPage extends ConsumerStatefulWidget {
  const UniversitiesByCategoryPage({super.key});

  @override
  ConsumerState<UniversitiesByCategoryPage> createState() => _UniversitiesByCategoryPageState();
}

class _UniversitiesByCategoryPageState extends ConsumerState<UniversitiesByCategoryPage> {
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

    if (provider.isLoading && !provider.hasLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Group universities by category
    final Map<String, List<University>> universitiesByCategory = {};
    for (var course in provider.courses) {
      final categoryId = course.categoryId ?? 'uncategorized';
      final university = provider.universities.firstWhere(
        (u) => u.universityId == course.universityId,
        orElse: () => University(
          universityId: '',
          universityName: 'Unknown', createdAt: DateTime.now(),
          // Add other required fields with default values if necessary
        ),
      );
      if (university.universityId.isNotEmpty) {
        universitiesByCategory.putIfAbsent(categoryId, () => []);
        if (!universitiesByCategory[categoryId]!.any((u) => u.universityId == university.universityId)) {
          universitiesByCategory[categoryId]!.add(university);
        }
      }
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
      appBar: AppBar(title: const Text("Universities by Category")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: universitiesByCategory.keys.length,
          itemBuilder: (context, index) {
            final categoryId = universitiesByCategory.keys.elementAt(index);
            final categoryName = getCategoryName(categoryId);
            final universities = universitiesByCategory[categoryId]!;

            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16),
              child: ExpansionTile(
                title: Text(categoryName, style: const TextStyle(fontWeight: FontWeight.bold)),
                children: universities.map((university) {
                  return ListTile(
                    title: Text(university.universityName),
                    onTap: () {
                      // Filter courses for this university and category
                      final courses = provider.courses.where(
                        (c) => c.universityId == university.universityId && (c.categoryId ?? 'uncategorized') == categoryId,
                      ).toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CoursesGridPage(
                            title: "${university.universityName} - $categoryName",
                            courses: courses,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}