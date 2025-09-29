import 'package:azeducation/features/new_db/new_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddStreamPage extends ConsumerStatefulWidget {
  const AddStreamPage({super.key});

  @override
  ConsumerState<AddStreamPage> createState() => _AddStreamPageState();
}

class _AddStreamPageState extends ConsumerState<AddStreamPage> {
  final _controller = TextEditingController();
  String? _selectedStageId;
  String? _selectedBoardId;
  bool _loading = false;

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty ||
        _selectedStageId == null ||
        _selectedBoardId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select stage, board, and enter stream name")),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      debugPrint("✅ Adding stream '${_controller.text.trim()}' to boardId=$_selectedBoardId");

      await ref.read(educationServiceProvider).addStream(
            _controller.text.trim(),
            _selectedBoardId!,
          );

      // Refresh streams under this board
      ref.invalidate(streamListProvider(_selectedBoardId!));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Stream added successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e, st) {
      debugPrint("❌ Error while adding stream: $e");
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
      appBar: AppBar(title: const Text("Add Stream")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Stage dropdown
            stages.when(
              data: (stgs) {
                return DropdownButtonFormField<String>(
                  value: _selectedStageId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: "Stage"),
                  items: stgs
                      .map((s) => DropdownMenuItem(
                            value: s.stageId,
                            child: Text(s.stageName),
                          ))
                      .toList(),
                  onChanged: (val) {
                    debugPrint("🔽 Stage selected: $val");
                    setState(() {
                      _selectedStageId = val;
                      _selectedBoardId = null; // reset board selection
                    });
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => Text("Error loading stages: $e"),
            ),
            const SizedBox(height: 16),

            // Board dropdown (only if stage selected)
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
                          .map((b) => DropdownMenuItem(
                                value: b.boardId,
                                child: Text(b.boardName),
                              ))
                          .toList(),
                      onChanged: (val) {
                        debugPrint("🔽 Board selected: $val");
                        setState(() => _selectedBoardId = val);
                      },
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, st) => Text("Error loading boards: $e"),
                  );
                },
              ),
            const SizedBox(height: 16),

            // Stream name input
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Stream name"),
              onChanged: (val) => debugPrint("⌨️ Stream name typed: $val"),
            ),
            const SizedBox(height: 16),

            // Submit button
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text("Add"),
                  ),
          ],
        ),
      ),
    );
  }
}
