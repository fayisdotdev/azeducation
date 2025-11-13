import 'package:azeducation/features/auth/login_page.dart';
import 'package:azeducation/features/auth/student/student_signup.dart';
import 'package:azeducation/features/universities_tier/add/add_courses.dart';
import 'package:azeducation/features/universities_tier/show/universities_list_page.dart';
import 'package:azeducation/features/universities_tier/show/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
        if (!universitiesByCategory[categoryId]!.any(
          (u) => u.universityId == university.universityId,
        )) {
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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'login') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              } else if (value == 'signup') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentSignupPage()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'login',
                child: ListTile(
                  leading: Icon(Icons.login_outlined),
                  title: Text('Login'),
                ),
              ),
              const PopupMenuItem(
                value: 'signup',
                child: ListTile(
                  leading: Icon(Icons.person_add_alt_1_outlined),
                  title: Text('Signup'),
                ),
              ),
            ],
          ),
        ],
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

              return CategoryCard(
                categoryName: categoryName,
                universityCount: universities.length,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
