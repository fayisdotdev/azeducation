import 'package:azeducation/features/new_db/global/AddEnitityPage.dart';
import 'package:azeducation/features/new_db/new_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddStreamPage extends ConsumerStatefulWidget {
  const AddStreamPage({super.key});

  @override
  ConsumerState<AddStreamPage> createState() => _AddStreamPageState();
}

class _AddStreamPageState extends ConsumerState<AddStreamPage> {
  @override
  Widget build(BuildContext context) {
    return AddEntityPage(
      title: "Stream",
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
      ],
      onSubmit: (ref, name, selections) async {
        await ref
            .read(educationServiceProvider)
            .addStream(name, selections["boardId"]!);
        ref.invalidate(streamListProvider(selections["boardId"]!));
      },
    );
  }
}
