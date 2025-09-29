import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Helper class for dropdown configuration
class DropdownConfig {
  final String label;
  final String keyName;
  final AsyncValue<List<DropdownItem>> Function(WidgetRef ref, Map<String, String> selections) itemsProvider;

  DropdownConfig({required this.label, required this.keyName, required this.itemsProvider});
}

/// Standardized dropdown item
class DropdownItem {
  final String id;
  final String name;

  DropdownItem({required this.id, required this.name});
}

class AddEntityPage extends ConsumerStatefulWidget {
  final String title;
  final List<DropdownConfig> dropdowns;
  final Future<void> Function(WidgetRef ref, String name, Map<String, String> selections) onSubmit;

  const AddEntityPage({
    super.key,
    required this.title,
    required this.dropdowns,
    required this.onSubmit,
  });

  @override
  ConsumerState<AddEntityPage> createState() => _AddEntityPageState();
}

class _AddEntityPageState extends ConsumerState<AddEntityPage> {
  final _controller = TextEditingController();
  final Map<String, String> _selections = {};
  bool _loading = false;

  Future<void> _submit() async {
    // Validate dropdowns and text
    if (_controller.text.trim().isEmpty ||
        widget.dropdowns.any((d) => _selections[d.keyName] == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await widget.onSubmit(ref, _controller.text.trim(), _selections);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.title} added successfully")),
      );
      Navigator.pop(context);
    } catch (e, st) {
      debugPrint("❌ Error adding ${widget.title}: $e\n$st");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add ${widget.title}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Dynamic dropdowns
              ...widget.dropdowns.map((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Consumer(
                      builder: (context, ref, _) {
                        final items = d.itemsProvider(ref, _selections);
                        return items.when(
                          data: (list) => DropdownButtonFormField<String>(
                            value: _selections[d.keyName],
                            decoration: InputDecoration(labelText: d.label),
                            isExpanded: true,
                            items: list
                                .map((e) => DropdownMenuItem(
                                      value: e.id,
                                      child: Text(e.name),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                _selections[d.keyName] = val!;
                                // Reset dependent dropdowns
                                final index = widget.dropdowns.indexOf(d);
                                for (var i = index + 1; i < widget.dropdowns.length; i++) {
                                  _selections.remove(widget.dropdowns[i].keyName);
                                }
                              });
                            },
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (e, _) => Text("Error loading ${d.label}: $e"),
                        );
                      },
                    ),
                  )),

              // Name input
              TextField(
                controller: _controller,
                decoration: InputDecoration(labelText: "${widget.title} Name"),
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
      ),
    );
  }
}
