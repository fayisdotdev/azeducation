import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../new_provider.dart';
import '../subjects/subjects_page.dart';

class StreamsPage extends ConsumerWidget {
  final String boardId;
  final String boardName;

  const StreamsPage({super.key, required this.boardId, required this.boardName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streams = ref.watch(streamListProvider(boardId));

    return Scaffold(
      appBar: AppBar(title: Text("Streams - $boardName")),
      body: streams.when(
        data: (streamList) {
          if (streamList.isEmpty) return const Center(child: Text("No streams available."));
          return ListView.builder(
            itemCount: streamList.length,
            itemBuilder: (context, index) {
              final stream = streamList[index];
              return ListTile(
                title: Text(stream.streamName),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubjectsPage(streamId: stream.streamId, streamName: stream.streamName),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error loading streams: $e")),
      ),
    );
  }
}
