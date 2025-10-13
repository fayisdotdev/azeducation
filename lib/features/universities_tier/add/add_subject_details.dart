import 'package:azeducation/features/universities_tier/add/add_university.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AddSubjectDetailPage extends ConsumerStatefulWidget {
  const AddSubjectDetailPage({super.key});

  @override
  ConsumerState<AddSubjectDetailPage> createState() =>
      _AddSubjectDetailPageState();
}

class _AddSubjectDetailPageState extends ConsumerState<AddSubjectDetailPage> {
  String? selectedUniversityId;
  String? selectedCourseId;
  String? selectedSubjectId;

  final _descriptionController = TextEditingController();
  // final _durationController = TextEditingController();
  // final _feesController = TextEditingController();
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dataProvider).fetchAll(); // load universities, courses, subjects
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dataProvider);

    final coursesForUni = provider.courses
        .where((c) => c.universityId == selectedUniversityId)
        .toList();

    final subjectsForCourse = provider.subjects
        .where((s) => s.courseId == selectedCourseId)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Subject Detail")),
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
                          .map(
                            (u) => DropdownMenuItem(
                              value: u.universityId,
                              child: Text(u.universityName),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() {
                        selectedUniversityId = val;
                        selectedCourseId = null;
                        selectedSubjectId = null;
                      }),
                    ),
                    const SizedBox(height: 16),

                    // ===== Course Dropdown =====
                    DropdownButtonFormField<String>(
                      value: selectedCourseId,
                      hint: const Text("Select Course"),
                      items: coursesForUni
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.courseId,
                              child: Text(c.courseName),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() {
                        selectedCourseId = val;
                        selectedSubjectId = null;
                      }),
                    ),
                    const SizedBox(height: 16),

                    // ===== Subject Dropdown =====
                    DropdownButtonFormField<String>(
                      value: selectedSubjectId,
                      hint: const Text("Select Subject"),
                      items: subjectsForCourse
                          .map(
                            (s) => DropdownMenuItem(
                              value: s.subjectId,
                              child: Text(s.subjectName),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => selectedSubjectId = val),
                    ),
                    const SizedBox(height: 16),

                    // ===== Subject Detail Inputs =====
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                    ),
                    // TextField(
                    //   controller: _durationController,
                    //   decoration: const InputDecoration(labelText: "Duration"),
                    // ),
                    // TextField(
                    //   controller: _feesController,
                    //   decoration: const InputDecoration(labelText: "Fees"),
                    //   keyboardType: TextInputType.number,
                    // ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              if (selectedUniversityId == null ||
                                  selectedCourseId == null ||
                                  selectedSubjectId == null ||
                                  _descriptionController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please fill all required fields",
                                    ),
                                  ),
                                );
                                return;
                              }

                              final detail = CourseDetail(
                                detailId: _uuid.v4(),
                                universityId: selectedUniversityId!,
                                courseId: selectedCourseId!,
                                subjectId: selectedSubjectId!,
                                createdAt: DateTime.now(),
                                description: _descriptionController.text,
                                // duration and fees are left null
                              );

                              await ref
                                  .read(dataProvider)
                                  .addCourseDetail(detail);
                              Navigator.pop(context);
                            },
                      child: provider.isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Add Subject Details"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
