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
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            const Text("Core Subjects", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            coreSubjects.when(
              data: (coreList) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: coreList.map((c) => Text(c.subjectName)).toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text("Error loading core subjects: $e"),
            ),
            const SizedBox(height: 16),
            const Text("Electives", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            electives.when(
              data: (electiveList) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: electiveList.map((e) => Text(e.subjectName)).toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text("Error loading electives: $e"),
            ),
          ],
        ),
      ),
    );
  }
}


class SubjectsPageTab extends ConsumerStatefulWidget {
  const SubjectsPageTab({super.key});

  @override
  ConsumerState<SubjectsPageTab> createState() => _SubjectsPageTabState();
}

class _SubjectsPageTabState extends ConsumerState<SubjectsPageTab> {
  String? selectedStreamId;
  String? selectedStreamName;

  @override
  Widget build(BuildContext context) {
    final streams = ref.watch(allStreamsProvider); // fetch all streams

    return streams.when(
      data: (streamList) {
        return Column(
          children: [
            DropdownButton<String>(
              hint: const Text("Select Stream"),
              value: selectedStreamId,
              items: streamList.map((s) {
                return DropdownMenuItem(
                  value: s.streamId,
                  child: Text(s.streamName),
                );
              }).toList(),
              onChanged: (val) {
                final stream = streamList.firstWhere((s) => s.streamId == val);
                setState(() {
                  selectedStreamId = stream.streamId;
                  selectedStreamName = stream.streamName;
                });
              },
            ),
            if (selectedStreamId != null)
              Expanded(
                child: SubjectsPage(
                  streamId: selectedStreamId!,
                  streamName: selectedStreamName!,
                ),
              ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text("Error loading streams: $e"),
    );
  }
}
