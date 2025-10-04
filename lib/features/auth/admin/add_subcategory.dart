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
  if (_controller.text.trim().isEmpty || _selectedCategoryId == null) {
    debugPrint("Submission blocked: no subcategory name or category selected");
    return; // ✅ prevents sending invalid UUID
  }

  debugPrint("Adding subcategory '${_controller.text}' for category '$_selectedCategoryId'");

  try {
    await ref
        .read(courseServiceProvider)
        .addSubCategory(_controller.text.trim(), _selectedCategoryId!);
    ref.invalidate(subCategoryListProvider(_selectedCategoryId!));
    debugPrint("Subcategory added successfully");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Subcategory added")),
      );
      Navigator.pop(context);
    }
  } catch (e, stack) {
    debugPrint("Error adding subcategory -> $e");
    debugPrint("$stack");
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
                debugPrint("AddSubCategoryPage: Loaded ${cats.length} categories");
                return DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  items: cats
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.categoryId,
                          child: Text(c.categoryName ?? 'Uncategorized'),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    debugPrint("AddSubCategoryPage: Selected category $val");
                    setState(() => _selectedCategoryId = val);
                  },
                  decoration: const InputDecoration(labelText: "Category"),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) {
                debugPrint("AddSubCategoryPage: Error loading categories -> $e");
                return const SizedBox(); // Don't show error in UI
              },
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Subcategory name"),
            ),
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _submit, child: const Text("Add")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                debugPrint("AddSubCategoryPage: Navigating to AddCategoryPage");
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
