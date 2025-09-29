import 'package:azeducation/features/new_db/new_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddElectivePage extends ConsumerStatefulWidget {
  const AddElectivePage({super.key});

  @override
  ConsumerState<AddElectivePage> createState() => _AddElectivePageState();
}

class _AddElectivePageState extends ConsumerState<AddElectivePage> {
  final _nameController = TextEditingController();
  String? _selectedStageId;
  String? _selectedBoardId;
  String? _selectedStreamId;
  bool _loading = false;

  Future<void> _submit() async {
    if (_nameController.text.trim().isEmpty || _selectedStreamId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      debugPrint("✅ Adding elective '${_nameController.text.trim()}' to streamId=$_selectedStreamId");

      await ref.read(educationServiceProvider).addElective(
            _nameController.text.trim(),
            _selectedStreamId!,
          );

      ref.invalidate(electivesProvider(_selectedStreamId!));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Elective added successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e, st) {
      debugPrint("❌ Error while adding elective: $e");
      debugPrintStack(stackTrace: st);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stages = ref.watch(stageListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Elective")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Stage Dropdown
              stages.when(
                data: (stgs) {
                  return DropdownButtonFormField<String>(
                    value: _selectedStageId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: "Stage"),
                    items: stgs
                        .map(
                          (s) => DropdownMenuItem<String>(
                            value: s.stageId,
                            child: Text(s.stageName),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedStageId = val;
                        _selectedBoardId = null;
                        _selectedStreamId = null;
                      });
                    },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text("Error loading stages: $e"),
              ),
              const SizedBox(height: 16),

              // Board Dropdown
              if (_selectedStageId != null)
                Consumer(
                  builder: (context, ref, _) {
                    final boards = ref.watch(boardListProvider(_selectedStageId!));
                    return boards.when(
                      data: (brds) => DropdownButtonFormField<String>(
                        value: _selectedBoardId,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: "Board"),
                        items: brds
                            .map(
                              (b) => DropdownMenuItem<String>(
                                value: b.boardId,
                                child: Text(b.boardName),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedBoardId = val;
                            _selectedStreamId = null;
                          });
                        },
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (e, _) => Text("Error loading boards: $e"),
                    );
                  },
                ),
              const SizedBox(height: 16),

              // Stream Dropdown
              if (_selectedBoardId != null)
                Consumer(
                  builder: (context, ref, _) {
                    final streams = ref.watch(streamListProvider(_selectedBoardId!));
                    return streams.when(
                      data: (strms) => DropdownButtonFormField<String>(
                        value: _selectedStreamId,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: "Stream"),
                        items: strms
                            .map(
                              (s) => DropdownMenuItem<String>(
                                value: s.streamId,
                                child: Text(s.streamName),
                              ),
                            )
                            .toList(),
                        onChanged: (val) => setState(() => _selectedStreamId = val),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (e, _) => Text("Error loading streams: $e"),
                    );
                  },
                ),
              const SizedBox(height: 16),

              // Elective name input
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Elective Name"),
              ),
              const SizedBox(height: 16),

              // Submit button
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _submit, child: const Text("Add")),
            ],
          ),
        ),
      ),
    );
  }
}
