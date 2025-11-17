import 'package:azeducation/features/universities_tier/university_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final dataProvider = ChangeNotifierProvider((ref) => DataProvider());

class AddUniversityPage extends ConsumerStatefulWidget {
  const AddUniversityPage({super.key});

  @override
  ConsumerState<AddUniversityPage> createState() => _AddUniversityPageState();
}

class _AddUniversityPageState extends ConsumerState<AddUniversityPage> {
  final _controller = TextEditingController();
  final _classificationController = TextEditingController();
  String? _selectedClassification;
  bool _creatingClassification = false;

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dataProvider);
    // Collect all unique, non-null, non-empty classifications from universities
    final classifications = provider.universities
        .map((u) => u.classifications)
        .where((c) => c != null && c.trim().isNotEmpty)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text("Add University")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "University Name"),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: !_creatingClassification
                      ? DropdownButtonFormField<String>(
                          value: _selectedClassification,
                          hint: const Text("Select Classification (optional)"),
                          items: [
                            ...classifications.map(
                              (c) =>
                                  DropdownMenuItem(value: c, child: Text(c!)),
                            ),
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedClassification = val),
                        )
                      : TextField(
                          controller: _classificationController,
                          decoration: const InputDecoration(
                            labelText: "New Classification",
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                !_creatingClassification
                    ? IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: "Add new classification",
                        onPressed: () =>
                            setState(() => _creatingClassification = true),
                      )
                    : IconButton(
                        icon: const Icon(Icons.check),
                        tooltip: "Use new classification",
                        onPressed: () {
                          if (_classificationController.text
                              .trim()
                              .isNotEmpty) {
                            setState(() {
                              _selectedClassification =
                                  _classificationController.text.trim();
                              _creatingClassification = false;
                            });
                          }
                        },
                      ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final name = _controller.text.trim();
                final classification =
                    _selectedClassification ??
                    _classificationController.text.trim();
                if (name.isNotEmpty) {
                  await ref
                      .read(dataProvider)
                      .addUniversity(
                        name,
                        classifications: classification.isNotEmpty
                            ? classification
                            : null,
                      );
                  Navigator.pop(context);
                }
              },
              child: provider.isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Add University"),
            ),
          ],
        ),
      ),
    );
  }
}
