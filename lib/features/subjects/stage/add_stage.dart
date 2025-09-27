import 'package:azeducation/features/subjects/subject_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddStagePage extends ConsumerStatefulWidget {
  const AddStagePage({super.key});

  @override
  ConsumerState<AddStagePage> createState() => _AddStagePageState();
}

class _AddStagePageState extends ConsumerState<AddStagePage> {
  final _controller = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _loading = true);
    try {
      await ref.read(subjectServiceProvider).addStage(_controller.text.trim());
      ref.invalidate(stageListProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Stage added")),
        );
        Navigator.pop(context);
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
