// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart'; // For ClientException

/// Helper class for dropdown configuration
class DropdownConfig {
  final String label;
  final String keyName;
  final AsyncValue<List<DropdownItem>> Function(
    WidgetRef ref,
    Map<String, String> selections,
  ) itemsProvider;

  DropdownConfig({
    required this.label,
    required this.keyName,
    required this.itemsProvider,
  });
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
  final Future<void> Function(
    WidgetRef ref,
    String name,
    Map<String, String> selections,
  ) onSubmit;

  /// Optional: if true, show its own AppBar (when used as full page)
  final bool showScaffold;

  const AddEntityPage({
    super.key,
    required this.title,
    required this.dropdowns,
    required this.onSubmit,
    this.showScaffold = true,
  });

  @override
  ConsumerState<AddEntityPage> createState() => _AddEntityPageState();
}

class _AddEntityPageState extends ConsumerState<AddEntityPage> {
  final _controller = TextEditingController();
  final Map<String, String> _selections = {};
  bool _loading = false;

  Future<void> _submit() async {
    // Check internet connectivity first
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("No internet connection. Please try again."),
          backgroundColor: Colors.red,
          action: SnackBarAction(label: "Retry", onPressed: _submit),
        ),
      );
      return;
    }

    // Validate input
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

      if (widget.showScaffold) Navigator.pop(context);
    } on ClientException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              "Network error: Unable to reach the server. Please check your connection."),
          backgroundColor: Colors.red,
          action: SnackBarAction(label: "Retry", onPressed: _submit),
        ),
      );
    } catch (e, st) {
      debugPrint("❌ Error adding ${widget.title}: $e\n$st");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formContent = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ...widget.dropdowns.map(
            (d) => Padding(
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
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selections[d.keyName] = val!;
                          // Reset dependent dropdowns
                          final index = widget.dropdowns.indexOf(d);
                          for (var i = index + 1;
                              i < widget.dropdowns.length;
                              i++) {
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
            ),
          ),

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
    );

    // ✅ Optionally wrap with Scaffold if used as standalone page
    if (widget.showScaffold) {
      return Scaffold(
        appBar: AppBar(title: Text("Add ${widget.title}")),
        body: SingleChildScrollView(child: formContent),
      );
    }

    // ✅ Otherwise return as a normal widget (for embedding)
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: SingleChildScrollView(child: formContent),
    );
  }
}
