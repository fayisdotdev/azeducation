import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../new_provider.dart';

class SubjectsPageTab extends ConsumerWidget {
  const SubjectsPageTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch all streams
    final streams = ref.watch(allStreamsProvider);

    return streams.when(
      data: (streamList) {
        if (streamList.isEmpty) {
          return const Center(child: Text("No streams available."));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: streamList.map((stream) {
              // For each stream, fetch core subjects & electives
              final coreSubjects = ref.watch(
                coreSubjectsProvider(stream.streamId),
              );
              final electives = ref.watch(electivesProvider(stream.streamId));

              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stream name as heading
                    Text(
                      stream.streamName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Core Subjects
                    const Text(
                      "Core Subjects",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    coreSubjects.when(
                      data: (coreList) {
                        if (coreList.isEmpty)
                          return const Text("No core subjects found.");
                        return Column(
                          children: coreList
                              .map((c) => ListTile(title: Text(c.subjectName)))
                              .toList(),
                        );
                      },
                      loading: () => const SizedBox(
                        height: 60,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => Text("Error loading core subjects: $e"),
                    ),
                    const SizedBox(height: 12),

                    // Electives
                    const Text(
                      "Electives",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    electives.when(
                      data: (electiveList) {
                        if (electiveList.isEmpty)
                          return const Text("No electives found.");
                        return Column(
                          children: electiveList
                              .map((e) => ListTile(title: Text(e.subjectName)))
                              .toList(),
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
              );
            }).toList(),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error loading streams: $e")),
    );
  }
}
