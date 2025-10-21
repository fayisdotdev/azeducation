import 'package:azeducation/providers/university/university_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final dataProvider = ChangeNotifierProvider((ref) => DataProvider());

class AddCoursePage extends ConsumerStatefulWidget {
  const AddCoursePage({super.key});

  @override
  ConsumerState<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends ConsumerState<AddCoursePage> {
  String? selectedUniversityId;
  String? selectedCategoryId;
  final _controller = TextEditingController();

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(dataProvider).fetchAll();
  });
}


  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Add Course")),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ===== University Dropdown =====
                  DropdownButtonFormField<String>(
                    value: selectedUniversityId,
                    hint: Text("Select University"),
                    items: provider.universities.isEmpty
                        ? []
                        : provider.universities
                              .map(
                                (u) => DropdownMenuItem(
                                  value: u.universityId,
                                  child: Text(u.universityName),
                                ),
                              )
                              .toList(),
                    onChanged: (val) =>
                        setState(() => selectedUniversityId = val),
                  ),

                  SizedBox(height: 16),

                  // ===== Category Dropdown =====
                  DropdownButtonFormField<String>(
                    value: selectedCategoryId,
                    hint: Text("Select Category (optional)"),
                    items: [
                      DropdownMenuItem(value: null, child: Text("Not Decided")),
                      ...provider.categories.map(
                        (c) => DropdownMenuItem(
                          value: c.categoryId,
                          child: Text(c.categoryName),
                        ),
                      ),
                    ],
                    onChanged: (val) =>
                        setState(() => selectedCategoryId = val),
                  ),

                  SizedBox(height: 16),

                  // ===== Course Name =====
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: "Course Name"),
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () async {
                      if (selectedUniversityId != null &&
                          _controller.text.isNotEmpty) {
                        await provider.addCourse(
                          selectedUniversityId!,
                          _controller.text,
                          categoryId: selectedCategoryId,
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please fill all required fields"),
                          ),
                        );
                      }
                    },
                    child: provider.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Add Course"),
                  ),
                ],
              ),
            ),
    );
  }
}
