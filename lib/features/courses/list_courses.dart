import 'package:azeducation/features/courses/all_courses.dart';
import 'package:azeducation/features/courses/category_courses.dart';
import 'package:azeducation/features/courses/subcategory_courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/auth/login_page.dart';

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: TabBarView(
        controller: _tabController,
        children: const [
          AllCoursesPage(),
          CategoryCoursesPage(),
          SubcategoryCoursesPage(),
        ],
      ),
    );
  }
}
