import 'package:azeducation/features/newUniversity/quick_university_add.dart';
import 'package:azeducation/features/universities_tier/add/addsession.dart';
import 'package:azeducation/features/universities_tier/show/show_mixed.dart';
import 'package:azeducation/features/universities_tier/show/university_by_category.dart';
import 'package:flutter/material.dart';

class UniversitySession extends StatelessWidget {
  const UniversitySession({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("University Admin Session")),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddSession()),
                    );
                  },
                  child: const Text("Add Session"),
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuickUniversityAddPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Quick Add University, Category, Course, Subject",
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UniversityCourseSubjectListPage(),
                      ),
                    );
                  },
                  child: const Text("Universities and Courses"),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UniversitiesByCategoryPage(),
                      ),
                    );
                  },
                  child: const Text("University by Category"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
