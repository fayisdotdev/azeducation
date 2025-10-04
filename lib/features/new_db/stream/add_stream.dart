import 'package:azeducation/features/new_db/global/add_enitity_page.dart';
import 'package:azeducation/features/new_db/new_model.dart';
import 'package:azeducation/features/new_db/new_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddStreamPage extends ConsumerStatefulWidget {
  const AddStreamPage({super.key});

  @override
  ConsumerState<AddStreamPage> createState() => _AddStreamPageState();
}

class _AddStreamPageState extends ConsumerState<AddStreamPage> {
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _feesController = TextEditingController();
  final _note1Controller = TextEditingController();
  final _note2Controller = TextEditingController();
  final _note3Controller = TextEditingController();
  final _curriculumController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _durationController.dispose();
    _feesController.dispose();
    _note1Controller.dispose();
    _note2Controller.dispose();
    _note3Controller.dispose();
    _curriculumController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Stream")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Stream Name + Dropdowns first
            AddEntityPage(
              showScaffold: false,
              title: "Stream",
              dropdowns: [
                DropdownConfig(
                  label: "Stage",
                  keyName: "stageId",
                  itemsProvider: (ref, _) => ref.watch(stageListProvider).whenData(
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
                    return ref.watch(boardListProvider(stageId)).whenData(
                          (list) => list
                              .map((b) => DropdownItem(id: b.boardId, name: b.boardName))
                              .toList(),
                        );
                  },
                ),
              ],
              onSubmit: (ref, name, selections) async {
                // 1️⃣ Add Stream
                final streamId = await ref
                    .read(educationServiceProvider)
                    .addStream(name, selections["boardId"]!);

                await ref.read(educationServiceProvider).addStreamDetails(
                  StreamDetailModel(
                    detailId: '',
                    streamId: streamId,
                    description: _descriptionController.text,
                    duration: _durationController.text,
                    fees: double.tryParse(_feesController.text),
                    note1: _note1Controller.text,
                    note2: _note2Controller.text,
                    note3: _note3Controller.text,
                    curriculum: _curriculumController.text,
                    imageUrl: _imageUrlController.text,
                    createdAt: null,
                  ),
                );

                ref.invalidate(streamListProvider(selections["boardId"]!));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Stream added successfully!")),
                );
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 24),

            // ✅ Stream Details Section
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: "Duration"),
            ),
            TextField(
              controller: _feesController,
              decoration: const InputDecoration(labelText: "Fees"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _note1Controller,
              decoration: const InputDecoration(labelText: "Note 1"),
            ),
            TextField(
              controller: _note2Controller,
              decoration: const InputDecoration(labelText: "Note 2"),
            ),
            TextField(
              controller: _note3Controller,
              decoration: const InputDecoration(labelText: "Note 3"),
            ),
            TextField(
              controller: _curriculumController,
              decoration: const InputDecoration(labelText: "Curriculum"),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: "Image URL"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
