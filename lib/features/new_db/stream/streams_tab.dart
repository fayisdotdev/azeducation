import 'package:azeducation/features/new_db/stream/streams_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../new_provider.dart';

class StreamsPageTab extends ConsumerWidget {
  const StreamsPageTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boards = ref.watch(allBoardsProvider); // Provider fetching all boards

    return Scaffold(
      appBar: AppBar(title: const Text("Select Board")),
      body: boards.when(
        data: (boardList) {
          if (boardList.isEmpty) {
            return const Center(child: Text("No boards available."));
          }

          return ListView.builder(
            itemCount: boardList.length,
            itemBuilder: (context, index) {
              final board = boardList[index];
              return ListTile(
                title: Text(board.boardName),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  // Navigate to StreamsPage with selected board
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StreamsPage(
                        boardId: board.boardId,
                        boardName: board.boardName,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error loading boards: $e")),
      ),
    );
  }
}
