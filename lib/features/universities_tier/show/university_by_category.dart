import 'package:azeducation/features/auth/login_page.dart';
import 'package:azeducation/features/auth/student/student_signup.dart';
import 'package:azeducation/features/universities_tier/add/add_courses.dart';
import 'package:azeducation/features/universities_tier/show/universities_list_page.dart';
import 'package:azeducation/features/universities_tier/show/show_mixed.dart';
import 'package:azeducation/features/universities_tier/show/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:azeducation/utils/error_utils.dart';

// RouteObserver for navigation-aware refresh
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

/// Provider to fetch featured university IDs from Supabase
final featuredUniversityIdsProvider = FutureProvider<List<String>>((ref) async {
  try {
    final supabase = Supabase.instance.client;
    final res = await supabase
        .from('featured_universities')
        .select('university_id');
    return res.map((e) => e['university_id'] as String).toList();
  } catch (e, st) {
    logError(e, st, 'fetch featured university ids');
    throw Exception(getFriendlyErrorMessage(e));
  }
});

class UniversitiesByCategoryPage extends ConsumerStatefulWidget {
  const UniversitiesByCategoryPage({super.key});

  @override
  ConsumerState<UniversitiesByCategoryPage> createState() =>
      _UniversitiesByCategoryPageState();
}

class _UniversitiesByCategoryPageState
    extends ConsumerState<UniversitiesByCategoryPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dataProvider).fetchAll();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route changes
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    // Unsubscribe from route changes
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when coming back to this page
    ref.read(dataProvider).fetchAll(forceRefresh: true);
  }

  String getCategoryName(String id, List<CourseCategory> categories) {
    if (id == 'uncategorized') return 'Uncategorized';
    return categories
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

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dataProvider);

    if (provider.isLoading && !provider.hasLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Load featured university IDs from provider
    final featuredUniversityIdsAsync = ref.watch(featuredUniversityIdsProvider);
    List<String> featuredUniversityIds = [];
    String? featuredError;
    if (featuredUniversityIdsAsync.hasError) {
      featuredError = featuredUniversityIdsAsync.error.toString();
    } else if (featuredUniversityIdsAsync.hasValue) {
      featuredUniversityIds = featuredUniversityIdsAsync.value ?? [];
    }
    final featuredUniversities = provider.universities
        .where((u) => featuredUniversityIds.contains(u.universityId))
        .toList();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (featuredError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    featuredError,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                )
              else if (featuredUniversityIdsAsync.isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (featuredUniversities.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 8),
                      child: Text(
                        '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: featuredUniversities.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, idx) {
                          final u = featuredUniversities[idx];
                          final universityCourses = provider.courses
                              .where((c) => c.universityId == u.universityId)
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
                                    builder: (_) => CoursesGridPage(
                                      title: u.universityName,
                                      courses: universityCourses,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 180,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      u.universityName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${universityCourses.length} courses',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    if (u.classifications != null &&
                                        u.classifications is List<String> &&
                                        (u.classifications as List<String>)
                                            .isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Wrap(
                                          spacing: 4,
                                          children:
                                              (u.classifications
                                                      as List<String>)
                                                  .map(
                                                    (c) => Chip(
                                                      label: Text(
                                                        c,
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                    ),
                                                  )
                                                  .toList(),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              Expanded(
                child: GridView.builder(
                  itemCount: universitiesByCategory.keys.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final categoryId = universitiesByCategory.keys.elementAt(
                      index,
                    );
                    final categoryName = getCategoryName(
                      categoryId,
                      provider.categories,
                    );
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
            ],
          ),
        ),
      ),
    );
  }
}
