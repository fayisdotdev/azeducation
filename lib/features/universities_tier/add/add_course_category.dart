import 'package:azeducation/features/universities_tier/university_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final dataProvider = ChangeNotifierProvider((ref) => DataProvider());

class CourseCategoryPage extends ConsumerStatefulWidget {
  const CourseCategoryPage({super.key});

  @override
  ConsumerState<CourseCategoryPage> createState() => _CourseCategoryPageState();
}

class _CourseCategoryPageState extends ConsumerState<CourseCategoryPage> {
  final TextEditingController _controller = TextEditingController();
  String? editingCategoryId;

  @override
  void initState() {
    super.initState();
    // fetch data when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dataProvider).fetchAll();
    });
  }

  void _resetForm() {
    _controller.clear();
    editingCategoryId = null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Course Categories")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== Form =====
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        labelText: editingCategoryId == null
                            ? "New Category"
                            : "Edit Category"),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_controller.text.isEmpty) return;
                    if (editingCategoryId == null) {
                      // add
                      await provider.addCourseCategory(_controller.text);
                    } else {
                      // update
                      await provider.updateCourseCategory(
                          editingCategoryId!, _controller.text);
                    }
                    _resetForm();
                  },
                  child: Text(editingCategoryId == null ? "Add" : "Update"),
                ),
              ],
            ),
            SizedBox(height: 20),
            // ===== Category List =====
            Expanded(
              child: provider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: provider.categories.length,
                      itemBuilder: (context, index) {
                        final category = provider.categories[index];
                        return ListTile(
                          title: Text(category.categoryName),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange),
                                onPressed: () {
                                  _controller.text = category.categoryName;
                                  setState(() {
                                    editingCategoryId = category.categoryId;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await provider.deleteCourseCategory(
                                      category.categoryId);
                                  if (editingCategoryId == category.categoryId) {
                                    _resetForm();
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
