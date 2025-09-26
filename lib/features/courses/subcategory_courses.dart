import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/providers/course_provider.dart';
import 'package:azeducation/widgets/course_card.dart';
import 'package:azeducation/models/course_model.dart';

class SubcategoryCoursesPage extends ConsumerWidget {
  const SubcategoryCoursesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(courseListProvider);
    final subCategoriesAsync = ref.watch(allSubCategoriesProvider);

    return coursesAsync.when(
      data: (courses) => subCategoriesAsync.when(
        data: (subCategories) {
          final subCategoryMap = {
            for (var s in subCategories) s.subCategoryId: s.subcategoryName,
          };

          final Map<String?, List<CourseModel>> grouped = {};
          for (var c in courses) {
            grouped.putIfAbsent(c.subcategoryId, () => []).add(c);
          }

          return ListView(
            children: grouped.entries.map<Widget>((entry) {
              final subId = entry.key;
              final subCourses = entry.value;
              final subName = subCategoryMap[subId] ?? "Uncategorized";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      subName,
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
                    itemCount: subCourses.length,
                    itemBuilder: (context, index) {
                      return CourseCard(course: subCourses[index]);
                    },
                  ),
                ],
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text("Error loading subcategories:\n$err",
              style: const TextStyle(color: Colors.red)),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Text("Error loading courses:\n$err",
            style: const TextStyle(color: Colors.red)),
      ),
    );
  }
}
