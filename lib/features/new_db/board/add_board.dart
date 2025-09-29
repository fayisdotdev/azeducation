import 'package:azeducation/features/new_db/new_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBoardPage extends ConsumerStatefulWidget {
  const AddBoardPage({super.key});

  @override
  ConsumerState<AddBoardPage> createState() => _AddBoardPageState();
}

class _AddBoardPageState extends ConsumerState<AddBoardPage> {
  final _controller = TextEditingController();
  String? _selectedStageId;
  bool _loading = false;

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty || _selectedStageId == null) {
      debugPrint(
          "⚠️ Submit blocked: boardName=${_controller.text}, stageId=$_selectedStageId");
      return;
    }

    setState(() => _loading = true);
    try {
      debugPrint(
          "✅ Adding board '${_controller.text.trim()}' to stageId=$_selectedStageId");

      await ref
          .read(educationServiceProvider)
          .addBoard(_controller.text.trim(), _selectedStageId!);

      // Refresh boards under this stage
      ref.invalidate(boardListProvider(_selectedStageId!));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Board added successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e, st) {
      debugPrint("❌ Error while adding board: $e");
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
      appBar: AppBar(title: const Text("Add Board")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown for stage
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
                    debugPrint("🔽 Stage selected: $val");
                    setState(() => _selectedStageId = val);
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => Text("Error: $e"),
            ),

            const SizedBox(height: 16),

            // Board name input
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Board name"),
              onChanged: (val) =>
                  debugPrint("⌨️ Board name typed: $val"),
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
