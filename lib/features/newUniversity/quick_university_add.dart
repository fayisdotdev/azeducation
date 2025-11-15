import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:azeducation/features/universities_tier/university_provider.dart';

final dataProvider = ChangeNotifierProvider((ref) => DataProvider());

class QuickUniversityAddPage extends ConsumerStatefulWidget {
  const QuickUniversityAddPage({super.key});

  @override
  ConsumerState<QuickUniversityAddPage> createState() =>
      _QuickUniversityAddPageState();
}

class _QuickUniversityAddPageState
    extends ConsumerState<QuickUniversityAddPage> {
  void _setupTextListeners() {
    _universityController.addListener(() => setState(() {}));
    _categoryController.addListener(() => setState(() {}));
    _courseController.addListener(() => setState(() {}));
    _subjectController.addListener(() => setState(() {}));
  }

  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  String? _universityId;
  String? _categoryId;
  String? _courseId;

  // Track if user is creating new for each entity
  bool _creatingUniversity = false;
  bool _creatingCategory = false;
  bool _creatingCourse = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch all data on page open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dataProvider).fetchAll(forceRefresh: true);
    });
    _setupTextListeners();
  }

  Future<void> _addUniversity() async {
    setState(() => _isLoading = true);
    await ref.read(dataProvider).addUniversity(_universityController.text);
    final uni = ref.read(dataProvider).universities.last;
    setState(() {
      _universityId = uni.universityId;
      _categoryId = null;
      _courseId = null;
      _categoryController.clear();
      _courseController.clear();
      _creatingUniversity = false;
    });
    setState(() => _isLoading = false);
  }

  Future<void> _addCategory() async {
    setState(() => _isLoading = true);
    await ref.read(dataProvider).addCourseCategory(_categoryController.text);
    final cat = ref.read(dataProvider).categories.last;
    setState(() {
      _categoryId = cat.categoryId;
      _courseId = null;
      _courseController.clear();
      _creatingCategory = false;
    });
    setState(() => _isLoading = false);
  }

  Future<void> _addCourse() async {
    setState(() => _isLoading = true);
    await ref
        .read(dataProvider)
        .addCourse(
          _universityId!,
          _courseController.text,
          categoryId: _categoryId,
        );
    final course = ref.read(dataProvider).courses.last;
    setState(() {
      _courseId = course.courseId;
      _creatingCourse = false;
    });
    setState(() => _isLoading = false);
  }

  Future<void> _addSubject() async {
    setState(() => _isLoading = true);
    await ref
        .read(dataProvider)
        .addSubject(_courseId!, _universityId!, _subjectController.text);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(dataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Add University, Category, Course, Subject'),
      ),
      body: data.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  // --- University: Select OR Create ---
                  const Text('University'),
                  if (!_creatingUniversity)
                    Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _universityId,
                          items: data.universities
                              .map(
                                (u) => DropdownMenuItem(
                                  value: u.universityId,
                                  child: Text(u.universityName),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _universityId = val;
                              _categoryId = null;
                              _courseId = null;
                              _categoryController.clear();
                              _courseController.clear();
                            });
                          },
                          hint: const Text('Select University'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _creatingUniversity = true;
                              _universityId = null;
                              _categoryId = null;
                              _courseId = null;
                            });
                          },
                          child: const Text('Create New University'),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        TextField(
                          controller: _universityController,
                          decoration: const InputDecoration(
                            labelText: 'New University Name',
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed:
                                  _isLoading ||
                                      _universityController.text.isEmpty
                                  ? null
                                  : _addUniversity,
                              child: const Text('Add'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _creatingUniversity = false;
                                  _universityController.clear();
                                });
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // --- Category: Select OR Create ---
                  const Text('Category'),
                  if (!_creatingCategory)
                    Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _categoryId,
                          items: data.categories
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c.categoryId,
                                  child: Text(c.categoryName),
                                ),
                              )
                              .toList(),
                          onChanged: _universityId == null
                              ? null
                              : (val) {
                                  setState(() {
                                    _categoryId = val;
                                    _courseId = null;
                                    _courseController.clear();
                                  });
                                },
                          hint: const Text('Select Category'),
                        ),
                        TextButton(
                          onPressed: _universityId == null
                              ? null
                              : () {
                                  setState(() {
                                    _creatingCategory = true;
                                    _categoryId = null;
                                    _courseId = null;
                                  });
                                },
                          child: const Text('Create New Category'),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        TextField(
                          controller: _categoryController,
                          decoration: const InputDecoration(
                            labelText: 'New Category Name',
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed:
                                  _isLoading ||
                                      _categoryController.text.isEmpty ||
                                      _universityId == null
                                  ? null
                                  : _addCategory,
                              child: const Text('Add'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _creatingCategory = false;
                                  _categoryController.clear();
                                });
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // --- Course: Select OR Create ---
                  const Text('Course'),
                  if (!_creatingCourse)
                    Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _courseId,
                          items: data.courses
                              .where(
                                (c) =>
                                    c.universityId == _universityId &&
                                    c.categoryId == _categoryId,
                              )
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c.courseId,
                                  child: Text(c.courseName),
                                ),
                              )
                              .toList(),
                          onChanged:
                              (_universityId == null || _categoryId == null)
                              ? null
                              : (val) {
                                  setState(() {
                                    _courseId = val;
                                  });
                                },
                          hint: const Text('Select Course'),
                        ),
                        TextButton(
                          onPressed:
                              (_universityId == null || _categoryId == null)
                              ? null
                              : () {
                                  setState(() {
                                    _creatingCourse = true;
                                    _courseId = null;
                                  });
                                },
                          child: const Text('Create New Course'),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        TextField(
                          controller: _courseController,
                          decoration: const InputDecoration(
                            labelText: 'New Course Name',
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed:
                                  _isLoading ||
                                      _courseController.text.isEmpty ||
                                      _universityId == null ||
                                      _categoryId == null
                                  ? null
                                  : _addCourse,
                              child: const Text('Add'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _creatingCourse = false;
                                  _courseController.clear();
                                });
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // --- Subject List for this Course ---
                  if (_courseId != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Subjects in this Course:'),
                        Wrap(
                          spacing: 8,
                          children: data.subjects
                              .where((s) => s.courseId == _courseId)
                              .map((s) => Chip(label: Text(s.subjectName)))
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),

                  // --- Add Subject ---
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _subjectController,
                          decoration: const InputDecoration(
                            labelText: 'New Subject Name',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed:
                            _isLoading ||
                                _subjectController.text.isEmpty ||
                                _courseId == null ||
                                _universityId == null
                            ? null
                            : _addSubject,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
