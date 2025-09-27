import 'package:azeducation/features/subjects/stage/add_stage.dart';
import 'package:azeducation/features/subjects/subject_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddClassPage extends ConsumerStatefulWidget {
  const AddClassPage({super.key});

  @override
  ConsumerState<AddClassPage> createState() => _AddClassPageState();
}

class _AddClassPageState extends ConsumerState<AddClassPage> {
  final _controller = TextEditingController();
  String? _selectedStageId;
  bool _loading = false;

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty || _selectedStageId == null) {
      debugPrint("⚠️ Submit blocked: className=${_controller.text}, stageId=$_selectedStageId");
      return;
    }

    setState(() => _loading = true);
    try {
      debugPrint("✅ Adding class '${_controller.text.trim()}' to stageId=$_selectedStageId");
      await ref
          .read(subjectServiceProvider)
          .addClass(_controller.text.trim(), _selectedStageId!);

      ref.invalidate(classListProvider(_selectedStageId!));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Class added")),
        );
        Navigator.pop(context);
      }
    } catch (e, st) {
      debugPrint("❌ Error while adding class: $e");
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
      appBar: AppBar(title: const Text("Add Class")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            stages.when(
              data: (stgs) {
                debugPrint("📦 Loaded stages: ${stgs.map((s) => "${s.stageId}:${s.stageName}").toList()}");

                return DropdownButtonFormField<String>(
                  value: _selectedStageId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: "Stage"),
                  items: stgs
                      // ignore: unnecessary_null_comparison
                      .where((s) => s.stageId != null) // filter nulls if any
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
              loading: () {
                debugPrint("⏳ Loading stages...");
                return const CircularProgressIndicator();
              },
              error: (e, st) {
                debugPrint("❌ Failed to load stages: $e");
                debugPrintStack(stackTrace: st);
                return Text("Error: $e");
              },
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Class name"),
              onChanged: (val) => debugPrint("⌨️ Class name typed: $val"),
            ),
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text("Add"),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddStagePage()),
                );
              },
              child: const Text("Add stage"),
            ),
          ],
        ),
      ),
    );
  }
}
