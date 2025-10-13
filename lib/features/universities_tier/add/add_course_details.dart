import 'package:azeducation/features/universities_tier/add/add_university.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AddCourseDetailPage extends ConsumerStatefulWidget {
  const AddCourseDetailPage({super.key});

  @override
  ConsumerState<AddCourseDetailPage> createState() =>
      _AddCourseDetailPageState();
}

class _AddCourseDetailPageState extends ConsumerState<AddCourseDetailPage> {
  String? selectedUniversityId;
  String? selectedCourseId;

  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _feesController = TextEditingController();
  final _uuid = const Uuid();

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

    final coursesForSelectedUni = provider.courses
        .where((c) => c.universityId == selectedUniversityId)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Course Detail")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
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
                        selectedCourseId = null; // reset course
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

                    // ===== Course Detail Inputs =====
                    TextField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: "Description"),
                    ),
                    TextField(
                      controller: _durationController,
                      decoration: const InputDecoration(labelText: "Duration"),
                    ),
                    TextField(
                      controller: _feesController,
                      decoration: const InputDecoration(labelText: "Fees"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              if (selectedUniversityId == null ||
                                  selectedCourseId == null ||
                                  _descriptionController.text.isEmpty ||
                                  _durationController.text.isEmpty ||
                                  _feesController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Please fill all required fields")),
                                );
                                return;
                              }

                              final detail = CourseDetail(
                                detailId: _uuid.v4(),
                                universityId: selectedUniversityId!,
                                courseId: selectedCourseId!,
                                createdAt: DateTime.now(),
                                description: _descriptionController.text,
                                duration: _durationController.text,
                                fees: num.tryParse(_feesController.text),
                              );

                              await ref.read(dataProvider).addCourseDetail(detail);
                              Navigator.pop(context);
                            },
                      child: provider.isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Add Details"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
