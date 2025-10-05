import 'package:azeducation/features/new_db/board/boards_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/new_db/new_provider.dart';

class StagesPage extends ConsumerWidget {
  const StagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagesAsync = ref.watch(stageListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stages"),
        centerTitle: true,
      ),
      body: stagesAsync.when(
        data: (stages) {
          if (stages.isEmpty) {
            return const Center(
              child: Text("No stages available."),
            );
          }

          return ListView.separated(
            itemCount: stages.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final stage = stages[index];
              return ListTile(
                title: Text(stage.stageName),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BoardsPage(
                        stageId: stage.stageId,
                        stageName: stage.stageName,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            "Error loading stages: $e",
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
