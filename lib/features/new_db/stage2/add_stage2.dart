import 'package:azeducation/features/new_db/new_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddStag2ePage extends ConsumerStatefulWidget {
  const AddStag2ePage({super.key});

  @override
  ConsumerState<AddStag2ePage> createState() => _AddStag2ePageState();
}

class _AddStag2ePageState extends ConsumerState<AddStag2ePage> {
  final _controller = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    final stageName = _controller.text.trim();
    if (stageName.isEmpty) return;

    setState(() => _loading = true);
    try {
      // ✅ Use the new provider
      await ref.read(educationServiceProvider).addStage(stageName);

      // Refresh the stage list provider
      ref.invalidate(stageListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Stage added")),
        );
        Navigator.pop(context);
      }
    } catch (e, st) {
      debugPrint("❌ Failed to add stage: $e\n$st");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add stage: $e")),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Stage")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Stage name"),
            ),
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _submit, child: const Text("Add")),
          ],
        ),
      ),
    );
  }
}
