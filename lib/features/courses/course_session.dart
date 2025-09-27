import 'package:azeducation/features/auth/admin/add_category.dart';
import 'package:azeducation/features/auth/admin/add_subcategory.dart';
import 'package:azeducation/features/courses/add_courses.dart';
import 'package:azeducation/features/courses/list_courses.dart';
import 'package:flutter/material.dart';

class CourseSession extends StatelessWidget {
  const CourseSession({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subject Session")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddCoursePage()),
                  );
                },
                child: const Text("Add Course"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddCategoryPage()),
                  );
                },
                child: const Text("Add Category"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddSubCategoryPage()),
                  );
                },
                child: const Text("Add Subcategory"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CourseListPage()),
                  );
                },
                child: const Text("Show Courses"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
