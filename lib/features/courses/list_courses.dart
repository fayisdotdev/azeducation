import 'package:azeducation/providers/course_provider.dart';
import 'package:azeducation/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/auth/login_page.dart';
import 'package:azeducation/models/course_model.dart';

class CourseListPage extends ConsumerStatefulWidget {
  const CourseListPage({super.key});

  @override
  ConsumerState<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends ConsumerState<CourseListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(courseListProvider);
      ref.invalidate(categoryListProvider);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildGrid(List<CourseModel> courses) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (screenWidth > 800) crossAxisCount = 3;
    if (screenWidth > 1200) crossAxisCount = 4;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.88,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return CourseCard(course: courses[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(courseListProvider);
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "By Category"),
            Tab(text: "By Subcategory"),
          ],
        ),
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
      body: Builder(
        builder: (context) {
          final subCategoriesAsync = ref.watch(allSubCategoriesProvider);

          return TabBarView(
            controller: _tabController,
            children: [
              // --- TAB 1: All Courses ---
              coursesAsync.when(
                data: (courses) => courses.isEmpty
                    ? const Center(child: Text("No courses added yet."))
                    : _buildGrid(courses),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Text(
                    "Error loading courses:\n$err",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

              // --- TAB 2: By Category ---
              categoriesAsync.when(
                data: (categories) {
                  if (categories.isEmpty) {
                    return const Center(
                      child: Text("No categories available."),
                    );
                  }

                  return coursesAsync.when(
                    data: (courses) {
                      return ListView(
                        children: categories.map<Widget>((cat) {
                          final catCourses = courses
                              .where((c) => c.categoryId == cat.categoryId)
                              .toList();

                          if (catCourses.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Text(
                                  cat.categoryName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _buildGrid(catCourses),
                            ],
                          );
                        }).toList(),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(
                      child: Text(
                        "Error loading courses:\n$err",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Text(
                    "Error loading categories:\n$err",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

              // --- TAB 3: By Subcategory ---
              coursesAsync.when(
                data: (courses) => subCategoriesAsync.when(
                  data: (subCategories) {
                    final subCategoryMap = {
                      for (var s in subCategories)
                        s.subCategoryId: s.subcategoryName,
                    };
                    // Group by subcategory
                    final Map<String?, List<CourseModel>> grouped = {};
                    for (var c in courses) {
                      grouped.putIfAbsent(c.subcategoryId, () => []).add(c);
                    }

                    return ListView(
                      children: grouped.entries.map<Widget>((entry) {
                        final subId = entry.key;
                        final subCourses = entry.value;
                        final subName =
                            subCategoryMap[subId] ?? "Uncategorized";

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Text(
                                subName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildGrid(subCourses),
                          ],
                        );
                      }).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(
                    child: Text(
                      "Error loading subcategories:\n$err",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Text(
                    "Error loading courses:\n$err",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
