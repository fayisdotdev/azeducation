import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/providers/course_provider.dart';
import 'package:azeducation/widgets/course_card.dart';

class CategoryCoursesPage extends ConsumerWidget {
  const CategoryCoursesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(courseListProvider);
    final categoriesAsync = ref.watch(categoryListProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const Center(child: Text("No categories available."));
        }

        return coursesAsync.when(
          data: (courses) {
            return ListView(
              children: categories.map<Widget>((cat) {
                final catCourses = courses
                    .where((c) => c.categoryId == cat.categoryId)
                    .toList();

                if (catCourses.isEmpty) return const SizedBox.shrink();

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
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.88,
                      ),
                      itemCount: catCourses.length,
                      itemBuilder: (context, index) {
                        return CourseCard(course: catCourses[index]);
                      },
                    ),
                  ],
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Text("Error loading courses:\n$err",
                style: const TextStyle(color: Colors.red)),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Text("Error loading categories:\n$err",
            style: const TextStyle(color: Colors.red)),
      ),
    );
  }
}
