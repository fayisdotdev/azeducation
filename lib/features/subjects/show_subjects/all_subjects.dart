import 'package:azeducation/widgets/subject_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/subjects/subject_provider.dart';

class AllSubjectsPage extends ConsumerWidget {
  const AllSubjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(allSubjectsProvider);

    return subjectsAsync.when(
      data: (subjects) => subjects.isEmpty
          ? const Center(child: Text("No subjects available"))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.88,
              ),
              itemCount: subjects.length,
              itemBuilder: (context, index) =>
                  SubjectCard(subject: subjects[index]),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          "Error loading subjects:\n$e",
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
