import 'package:azeducation/features/new_db/new_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EducationSummaryPage extends ConsumerWidget {
  const EducationSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stages = ref.watch(stageListProvider);

    void refreshData() {
      ref.invalidate(stageListProvider); // invalidate stages
      // optionally, invalidate other providers too
      ref.invalidate(boardListProvider);
      ref.invalidate(streamListProvider);
      ref.invalidate(coreSubjectsProvider);
      ref.invalidate(electivesProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Refreshing data...")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Education Summary"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshData,
            tooltip: "Refresh Data",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: stages.when(
          data: (stageList) {
            return ListView(
              children: stageList.map<Widget>((stage) {
                final boards = ref.watch(boardListProvider(stage.stageId));

                return boards.when(
                  data: (boardList) {
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Stage: ${stage.stageName}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...boardList.map<Widget>((board) {
                              final streams = ref.watch(
                                streamListProvider(board.boardId),
                              );

                              return streams.when(
                                data: (streamList) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Card(
                                        color: Colors.grey[100],
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Board: ${board.boardName}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              ...streamList.map<Widget>((
                                                stream,
                                              ) {
                                                final cores = ref.watch(
                                                  coreSubjectsProvider(
                                                    stream.streamId,
                                                  ),
                                                );
                                                final electives = ref.watch(
                                                  electivesProvider(
                                                    stream.streamId,
                                                  ),
                                                );

                                                return Card(
                                                  color: Colors.white,
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                      ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Stream: ${stream.streamName}",
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        cores.when(
                                                          data: (coreList) => Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: coreList
                                                                .map<Widget>(
                                                                  (
                                                                    c,
                                                                  ) => Padding(
                                                                    padding:
                                                                        const EdgeInsets.symmetric(
                                                                          vertical:
                                                                              2,
                                                                        ),
                                                                    child: Text(
                                                                      "Core: ${c.subjectName}",
                                                                    ),
                                                                  ),
                                                                )
                                                                .toList(),
                                                          ),
                                                          loading: () =>
                                                              const CircularProgressIndicator(),
                                                          error: (e, st) => Text(
                                                            "Error loading core subjects: $e",
                                                          ),
                                                        ),
                                                        electives.when(
                                                          data: (electiveList) => Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: electiveList
                                                                .map<Widget>(
                                                                  (
                                                                    e,
                                                                  ) => Padding(
                                                                    padding:
                                                                        const EdgeInsets.symmetric(
                                                                          vertical:
                                                                              2,
                                                                        ),
                                                                    child: Text(
                                                                      "Elective: ${e.subjectName}",
                                                                    ),
                                                                  ),
                                                                )
                                                                .toList(),
                                                          ),
                                                          loading: () =>
                                                              const CircularProgressIndicator(),
                                                          error: (e, st) => Text(
                                                            "Error loading electives: $e",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                loading: () => const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: CircularProgressIndicator(),
                                ),
                                error: (e, st) =>
                                    Text("Error loading streams: $e"),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Text("Error loading boards: $e"),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text("Error loading stages: $e")),
        ),
      ),
    );
  }
}
