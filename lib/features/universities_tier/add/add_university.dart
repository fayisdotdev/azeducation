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
  final Set<String> _selectedCategories = {}; // 🆕 store selected IDs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dataProvider).fetchAll(); // load categories
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Add University")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "University Name"),
            ),
            const SizedBox(height: 20),

            // ===== Category Selector =====
            Text("Select Course Categories",
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: provider.categories.length,
                      itemBuilder: (context, index) {
                        final category = provider.categories[index];
                        final isSelected =
                            _selectedCategories.contains(category.categoryId);
                        return CheckboxListTile(
                          title: Text(category.categoryName),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedCategories.add(category.categoryId);
                              } else {
                                _selectedCategories.remove(category.categoryId);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () async {
                      if (_controller.text.isEmpty ||
                          _selectedCategories.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Enter name and select at least one category.")),
                        );
                        return;
                      }
                      await ref.read(dataProvider).addUniversity(
                            _controller.text,
                            _selectedCategories.toList(),
                          );
                      Navigator.pop(context);
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
