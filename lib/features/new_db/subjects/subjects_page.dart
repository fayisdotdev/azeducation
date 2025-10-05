import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../new_provider.dart';

class SubjectsPage extends ConsumerWidget {
  final String streamId;
  final String streamName;

  const SubjectsPage({super.key, required this.streamId, required this.streamName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coreSubjects = ref.watch(coreSubjectsProvider(streamId));
    final electives = ref.watch(electivesProvider(streamId));

    return Scaffold(
      appBar: AppBar(title: Text("Subjects - $streamName")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Core Subjects",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            coreSubjects.when(
              data: (coreList) {
                if (coreList.isEmpty) return const Text("No core subjects found.");
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: coreList.length,
                  itemBuilder: (_, index) =>
                      ListTile(title: Text(coreList[index].subjectName)),
                );
              },
              loading: () => const SizedBox(
                height: 60,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text("Error loading core subjects: $e"),
            ),
            const SizedBox(height: 16),
            const Text(
              "Electives",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            electives.when(
              data: (electiveList) {
                if (electiveList.isEmpty) return const Text("No electives found.");
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: electiveList.length,
                  itemBuilder: (_, index) =>
                      ListTile(title: Text(electiveList[index].subjectName)),
                );
              },
              loading: () => const SizedBox(
                height: 60,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text("Error loading electives: $e"),
            ),
          ],
        ),
      ),
    );
  }
}