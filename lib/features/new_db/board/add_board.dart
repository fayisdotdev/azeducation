import 'package:azeducation/features/new_db/global/AddEnitityPage.dart';
import 'package:azeducation/features/new_db/new_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBoardPage extends ConsumerStatefulWidget {
  const AddBoardPage({super.key});

  @override
  ConsumerState<AddBoardPage> createState() => _AddBoardPageState();
}

class _AddBoardPageState extends ConsumerState<AddBoardPage> {
  @override
  Widget build(BuildContext context) {
    return AddEntityPage(
      title: "Board",
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
      ],
      onSubmit: (ref, name, selections) async {
        await ref
            .read(educationServiceProvider)
            .addBoard(name, selections["stageId"]!);
        ref.invalidate(boardListProvider(selections["stageId"]!));
      },
    );
  }
}
