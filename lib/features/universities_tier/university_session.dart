import 'package:azeducation/features/universities_tier/add/add_course_category.dart';
import 'package:azeducation/features/universities_tier/add/add_courses.dart';
import 'package:azeducation/features/universities_tier/add/add_subject.dart';
import 'package:azeducation/features/universities_tier/add/add_university.dart';
import 'package:flutter/material.dart';

class UniversitySession extends StatelessWidget {
  const UniversitySession({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("University Session")),
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
                    MaterialPageRoute(builder: (_) => const AddUniversityPage()),
                  );
                },
                child: const Text("Add University"),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddCoursePage()),
                  );
                },
                child: const Text("Add courses"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddSubjectPage()),
                  );
                },
                child: const Text("Add subjects"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddSubjectPage()),
                  );
                },
                child: const Text("Add subject Details"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CourseCategoryPage(),
                    ),
                  );
                },
                child: const Text("Add Category"),
              ),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (_) => const AddElectivePage()),
              //     );
              //   },
              //   child: const Text("Add Elective subjects"),
              // ),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (_) => const EducationSummaryPage(),
              //       ),
              //     );
              //   },
              //   child: const Text("Show everything"),
              // ),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (_) => const EducationSummaryTabs(),
              //       ),
              //     );
              //   },
              //   child: const Text("Show everything tabs"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
