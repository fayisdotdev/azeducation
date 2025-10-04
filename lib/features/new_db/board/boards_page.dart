import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../new_provider.dart';
import '../stream/streams_page.dart';

class BoardsPage extends ConsumerWidget {
  final String stageId;
  final String stageName;

  const BoardsPage({super.key, required this.stageId, required this.stageName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boards = ref.watch(boardListProvider(stageId));

    return Scaffold(
      appBar: AppBar(title: Text("Boards - $stageName")),
      body: boards.when(
        data: (boardList) {
          if (boardList.isEmpty) return const Center(child: Text("No boards available."));
          return ListView.builder(
            itemCount: boardList.length,
            itemBuilder: (context, index) {
              final board = boardList[index];
              return ListTile(
                title: Text(board.boardName),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StreamsPage(boardId: board.boardId, boardName: board.boardName),
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
