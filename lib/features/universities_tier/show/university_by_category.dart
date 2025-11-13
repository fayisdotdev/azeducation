import 'package:azeducation/features/universities_tier/add/add_courses.dart';
import 'package:azeducation/features/universities_tier/show/show_mixed.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UniversitiesByCategoryPage extends ConsumerStatefulWidget {
  const UniversitiesByCategoryPage({super.key});

  @override
  ConsumerState<UniversitiesByCategoryPage> createState() =>
      _UniversitiesByCategoryPageState();
}

class _UniversitiesByCategoryPageState
    extends ConsumerState<UniversitiesByCategoryPage> {
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

    // ===== Group universities by category =====
    final Map<String, List<University>> universitiesByCategory = {};

    for (var course in provider.courses) {
      final categoryId = course.categoryId ?? 'uncategorized';
      final university = provider.universities.firstWhere(
        (u) => u.universityId == course.universityId,
        orElse: () => University(
          universityId: '',
          universityName: 'Unknown',
          createdAt: DateTime.now(),
        ),
      );

      if (university.universityId.isNotEmpty) {
        universitiesByCategory.putIfAbsent(categoryId, () => []);
        if (!universitiesByCategory[categoryId]!
            .any((u) => u.universityId == university.universityId)) {
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
      appBar: AppBar(
        title: const Text("Universities by Categories"),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(dataProvider).fetchAll(forceRefresh: true),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: universitiesByCategory.keys.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final categoryId = universitiesByCategory.keys.elementAt(index);
              final categoryName = getCategoryName(categoryId);
              final universities = universitiesByCategory[categoryId]!;

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
                        builder: (_) => UniversitiesListPage(
                          categoryName: categoryName,
                          categoryId: categoryId,
                          universities: universities,
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
                              size: 40, color: Colors.blue),
                          const SizedBox(height: 8),
                          Text(
                            categoryName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("${universities.length} universities"),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// SECOND SCREEN: Grid view of universities under selected category
class UniversitiesListPage extends ConsumerWidget {
  final String categoryName;
  final String categoryId;
  final List<University> universities;

  const UniversitiesListPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.universities,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: universities.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final university = universities[index];
            final courseCount = provider.courses
                .where((c) =>
                    c.universityId == university.universityId &&
                    (c.categoryId ?? 'uncategorized') == categoryId)
                .length;

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  final courses = provider.courses
                      .where((c) =>
                          c.universityId == university.universityId &&
                          (c.categoryId ?? 'uncategorized') == categoryId)
                      .toList();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CoursesGridPage(
                        title:
                            "${university.universityName} - $categoryName",
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
                        const Icon(Icons.account_balance_outlined,
                            size: 40, color: Colors.blue),
                        const SizedBox(height: 8),
                        Text(
                          university.universityName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text("$courseCount courses",
                            style: const TextStyle(fontSize: 13)),
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
