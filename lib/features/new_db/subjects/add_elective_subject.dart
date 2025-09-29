import 'package:azeducation/features/new_db/global/add_enitity_page.dart';
import 'package:azeducation/features/new_db/new_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddElectivePage extends ConsumerStatefulWidget {
  const AddElectivePage({super.key});

  @override
  ConsumerState<AddElectivePage> createState() => _AddElectivePageState();
}

class _AddElectivePageState extends ConsumerState<AddElectivePage> {
  @override
  Widget build(BuildContext context) {
    return AddEntityPage(
      title: "Elective",
      dropdowns: [
        DropdownConfig(
          label: "Stage",
          keyName: "stageId",
          itemsProvider: (ref, _) => ref
              .watch(stageListProvider)
              .whenData(
                (list) => list
                    .map((s) => DropdownItem(id: s.stageId, name: s.stageName))
                    .toList(),
              ),
        ),
        DropdownConfig(
          label: "Board",
          keyName: "boardId",
          itemsProvider: (ref, selections) {
            final stageId = selections["stageId"];
            if (stageId == null) return const AsyncValue.data([]);
            return ref
                .watch(boardListProvider(stageId))
                .whenData(
                  (list) => list
                      .map(
                        (b) => DropdownItem(id: b.boardId, name: b.boardName),
                      )
                      .toList(),
                );
          },
        ),
        DropdownConfig(
          label: "Stream",
          keyName: "streamId",
          itemsProvider: (ref, selections) {
            final boardId = selections["boardId"];
            if (boardId == null) return const AsyncValue.data([]);
            return ref
                .watch(streamListProvider(boardId))
                .whenData(
                  (list) => list
                      .map(
                        (s) => DropdownItem(id: s.streamId, name: s.streamName),
                      )
                      .toList(),
                );
          },
        ),
      ],
      onSubmit: (ref, name, selections) async {
        await ref
            .read(educationServiceProvider)
            .addElective(name, selections["streamId"]!);
        ref.invalidate(electivesProvider(selections["streamId"]!));
      },
    );
  }
}
