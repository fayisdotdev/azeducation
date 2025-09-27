import 'package:azeducation/widgets/subject_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/subjects/subject_provider.dart';

class SubjectsByClassPage extends ConsumerWidget {
  const SubjectsByClassPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classesAsync = ref.watch(allClassesProvider);

    return classesAsync.when(
      data: (classes) {
        if (classes.isEmpty) return const Center(child: Text("No classes found"));

        return ListView(
          children: classes.map((cls) {
            final subjectsAsync = ref.watch(subjectListByClassProvider(cls.classId));

            return subjectsAsync.when(
              data: (subjects) {
                if (subjects.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(cls.className,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.88,
                      ),
                      itemCount: subjects.length,
                      itemBuilder: (context, index) =>
                          SubjectCard(subject: subjects[index]),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text("Error: $e")),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text("Error loading classes: $e", style: const TextStyle(color: Colors.red))),
    );
  }
}
