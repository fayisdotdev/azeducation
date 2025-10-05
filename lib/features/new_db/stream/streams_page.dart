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

class StreamsPageTab extends ConsumerStatefulWidget {
  const StreamsPageTab({super.key});

  @override
  ConsumerState<StreamsPageTab> createState() => _StreamsPageTabState();
}

class _StreamsPageTabState extends ConsumerState<StreamsPageTab> {
  String? selectedBoardId;
  String? selectedBoardName;

  @override
  Widget build(BuildContext context) {
    final boards = ref.watch(allBoardsProvider); // You may need a provider that fetches all boards

    return boards.when(
      data: (boardList) {
        return Column(
          children: [
            DropdownButton<String>(
              hint: const Text("Select Board"),
              value: selectedBoardId,
              isExpanded: true,
              items: boardList.map((b) {
                return DropdownMenuItem(
                  value: b.boardId,
                  child: Text(b.boardName),
                );
              }).toList(),
              onChanged: (val) {
                final board = boardList.firstWhere((b) => b.boardId == val);
                setState(() {
                  selectedBoardId = board.boardId;
                  selectedBoardName = board.boardName;
                });
              },
            ),
            if (selectedBoardId != null)
              Expanded(
                child: StreamsPage(boardId: selectedBoardId!, boardName: selectedBoardName!),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error loading boards: $e")),
    );
  }
}
