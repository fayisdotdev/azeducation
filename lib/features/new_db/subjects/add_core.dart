import 'package:azeducation/features/new_db/new_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCoreSubjectPage extends ConsumerStatefulWidget {
  const AddCoreSubjectPage({super.key});

  @override
  ConsumerState<AddCoreSubjectPage> createState() => _AddCoreSubjectPageState();
}

class _AddCoreSubjectPageState extends ConsumerState<AddCoreSubjectPage> {
  final _controller = TextEditingController();
  String? _selectedStageId;
  String? _selectedBoardId;
  String? _selectedStreamId;
  bool _loading = false;

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty ||
        _selectedStageId == null ||
        _selectedBoardId == null ||
        _selectedStreamId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select stage, board, stream and enter subject name")),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      debugPrint("✅ Adding core subject '${_controller.text.trim()}' to streamId=$_selectedStreamId");

      await ref.read(educationServiceProvider).addCoreSubject(
            _controller.text.trim(),
            _selectedStreamId!,
          );

      ref.invalidate(coreSubjectsProvider(_selectedStreamId!));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Core subject added successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e, st) {
      debugPrint("❌ Error while adding core subject: $e");
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
      appBar: AppBar(title: const Text("Add Core Subject")),
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
                      _selectedBoardId = null;
                      _selectedStreamId = null;
                    });
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => Text("Error loading stages: $e"),
            ),
            const SizedBox(height: 16),

            // Board dropdown
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
                        setState(() {
                          _selectedBoardId = val;
                          _selectedStreamId = null;
                        });
                      },
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, st) => Text("Error loading boards: $e"),
                  );
                },
              ),
            const SizedBox(height: 16),

            // Stream dropdown
            if (_selectedBoardId != null)
              Consumer(
                builder: (context, ref, _) {
                  final streams = ref.watch(streamListProvider(_selectedBoardId!));
                  return streams.when(
                    data: (sList) => DropdownButtonFormField<String>(
                      value: _selectedStreamId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: "Stream"),
                      items: sList
                          .map((s) => DropdownMenuItem(
                                value: s.streamId,
                                child: Text(s.streamName),
                              ))
                          .toList(),
                      onChanged: (val) {
                        debugPrint("🔽 Stream selected: $val");
                        setState(() => _selectedStreamId = val);
                      },
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, st) => Text("Error loading streams: $e"),
                  );
                },
              ),
            const SizedBox(height: 16),

            // Subject input
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Subject Name"),
              onChanged: (val) => debugPrint("⌨️ Core subject typed: $val"),
            ),
            const SizedBox(height: 16),

            // Submit
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _submit, child: const Text("Add")),
          ],
        ),
      ),
    );
  }
}
