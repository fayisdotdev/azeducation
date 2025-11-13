import 'package:azeducation/features/universities_tier/show/show_mixed.dart';
import 'package:azeducation/features/universities_tier/show/widgets/university_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:azeducation/features/universities_tier/add/add_courses.dart';

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
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: universities.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, uniIndex) {
            final university = universities[uniIndex];
            final courseCount = provider.courses
                .where(
                  (c) =>
                      c.universityId == university.universityId &&
                      (c.categoryId ?? 'uncategorized') == categoryId,
                )
                .length;

            return UniversityCard(
              universityName: university.universityName,
              courseCount: courseCount,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CoursesGridPage(
                      title: university.universityName,
                      courses: provider.courses
                          .where(
                            (c) =>
                                c.universityId == university.universityId &&
                                (c.categoryId ?? 'uncategorized') == categoryId,
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
