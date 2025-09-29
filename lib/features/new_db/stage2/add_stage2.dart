import 'package:azeducation/features/new_db/global/AddEnitityPage.dart';
import 'package:azeducation/features/new_db/new_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddStage2Page extends ConsumerWidget {
  const AddStage2Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AddEntityPage(
      title: "Stage",
      dropdowns: [], // no dropdowns needed for stage
      onSubmit: (ref, name, selections) async {
        await ref.read(educationServiceProvider).addStage(name);
        ref.invalidate(stageListProvider);
      },
    );
  }
}
