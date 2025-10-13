import 'package:azeducation/features/universities_tier/add/add_course_category.dart';
import 'package:azeducation/features/universities_tier/add/add_course_details.dart';
import 'package:azeducation/features/universities_tier/add/add_courses.dart';
import 'package:azeducation/features/universities_tier/add/add_subject.dart';
import 'package:azeducation/features/universities_tier/add/add_subject_details.dart';
import 'package:azeducation/features/universities_tier/add/add_university.dart';
import 'package:azeducation/features/universities_tier/show/show_mixed.dart';
import 'package:azeducation/features/universities_tier/videos/add.dart';
import 'package:azeducation/features/universities_tier/videos/show.dart';
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
                    MaterialPageRoute(
                      builder: (_) => const AddUniversityPage(),
                    ),
                  );
                },
                child: const Text("Add University"),
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
                    MaterialPageRoute(
                      builder: (_) => const AddCourseDetailPage(),
                    ),
                  );
                },
                child: const Text("Add Course Details"),
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
                    MaterialPageRoute(builder: (_) => const AddSubjectDetailPage()),
                  );
                },
                child: const Text("Add Subject details"),
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
                child: const Text("Show everything"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UploadVideoPage(),
                    ),
                  );
                },
                child: const Text("Upload video"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VideoStreamPage(),
                    ),
                  );
                },
                child: const Text("show videos"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
