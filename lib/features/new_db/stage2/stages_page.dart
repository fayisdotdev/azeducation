import 'package:azeducation/features/new_db/board/boards_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/new_db/new_provider.dart';

class StagesPage extends ConsumerWidget {
  const StagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stages = ref.watch(stageListProvider);

    return stages.when(
      data: (stageList) {
        if (stageList.isEmpty) return const Center(child: Text("No stages available."));
        return ListView.builder(
          itemCount: stageList.length,
          itemBuilder: (context, index) {
            final stage = stageList[index];
            return ListTile(
              title: Text(stage.stageName),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BoardsPage(stageId: stage.stageId, stageName: stage.stageName),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error loading stages: $e")),
    );
  }
}
