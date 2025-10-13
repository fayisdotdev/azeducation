import 'package:azeducation/features/universities_tier/add/add_university.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSubjectPage extends ConsumerStatefulWidget {
  const AddSubjectPage({super.key});

  @override
  ConsumerState<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends ConsumerState<AddSubjectPage> {
  String? selectedUniversityId;
  String? selectedCourseId;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch all data safely after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dataProvider).fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dataProvider);

    final coursesForSelectedUni = provider.courses
        .where((c) => c.universityId == selectedUniversityId)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Subject")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ===== University Dropdown =====
                  DropdownButtonFormField<String>(
                    value: selectedUniversityId,
                    hint: const Text("Select University"),
                    items: provider.universities
                        .map((u) => DropdownMenuItem(
                              value: u.universityId,
                              child: Text(u.universityName),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() {
                      selectedUniversityId = val;
                      selectedCourseId = null;
                    }),
                  ),

                  const SizedBox(height: 16),

                  // ===== Course Dropdown =====
                  DropdownButtonFormField<String>(
                    value: selectedCourseId,
                    hint: const Text("Select Course"),
                    items: coursesForSelectedUni
                        .map((c) => DropdownMenuItem(
                              value: c.courseId,
                              child: Text(c.courseName),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedCourseId = val),
                  ),

                  const SizedBox(height: 16),

                  // ===== Subject Name Input =====
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: "Subject Name"),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            if (selectedUniversityId != null &&
                                selectedCourseId != null &&
                                _controller.text.isNotEmpty) {
                              await ref.read(dataProvider).addSubject(
                                    selectedCourseId!,
                                    selectedUniversityId!,
                                    _controller.text,
                                  );
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Please fill all required fields"),
                                ),
                              );
                            }
                          },
                    child: provider.isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Add Subject"),
                  ),
                ],
              ),
            ),
    );
  }
}
