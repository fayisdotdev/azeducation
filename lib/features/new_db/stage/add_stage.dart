import 'package:azeducation/features/new_db/global/add_enitity_page.dart';
import 'package:azeducation/features/new_db/new_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddstagePage extends ConsumerWidget {
  const AddstagePage({super.key});

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
