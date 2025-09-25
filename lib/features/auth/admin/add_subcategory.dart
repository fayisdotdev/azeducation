import 'package:azeducation/features/auth/admin/add_category.dart';
import 'package:azeducation/providers/course_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSubCategoryPage extends ConsumerStatefulWidget {
  const AddSubCategoryPage({super.key});

  @override
  ConsumerState<AddSubCategoryPage> createState() => _AddSubCategoryPageState();
}

class _AddSubCategoryPageState extends ConsumerState<AddSubCategoryPage> {
  final _controller = TextEditingController();
  String? _selectedCategoryId;
  bool _loading = false;

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty || _selectedCategoryId == null) return;

    setState(() => _loading = true);
    try {
      await ref
          .read(courseServiceProvider)
          .addSubCategory(_controller.text.trim(), _selectedCategoryId!);
      ref.invalidate(subCategoryListProvider(_selectedCategoryId!));
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Subcategory added")));
        Navigator.pop(context);
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Subcategory")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            categories.when(
              data: (cats) {
                return DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  items: cats
                      .map(
                        (c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.category_name)),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedCategoryId = val),
                  decoration: const InputDecoration(labelText: "Category"),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text("Error: $e"),
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Subcategory name"),
            ),
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _submit, child: const Text("Add")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddCategoryPage()),
                );
              },
              child: const Text("Add category"),
            ),
          ],
        ),
      ),
    );
  }
}
