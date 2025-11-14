import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:azeducation/features/universities_tier/university_provider.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';

final dataProvider = ChangeNotifierProvider((ref) => DataProvider());

class QuickUniversityAddPage extends ConsumerStatefulWidget {
  const QuickUniversityAddPage({super.key});

  @override
  ConsumerState<QuickUniversityAddPage> createState() =>
      _QuickUniversityAddPageState();
}

class _QuickUniversityAddPageState
    extends ConsumerState<QuickUniversityAddPage> {
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  String? _universityId;
  String? _categoryId;
  String? _courseId;

  bool _isLoading = false;

  Future<void> _addUniversity() async {
    setState(() => _isLoading = true);
    await ref.read(dataProvider).addUniversity(_universityController.text);
    final uni = ref.read(dataProvider).universities.last;
    _universityId = uni.universityId;
    setState(() => _isLoading = false);
  }

  Future<void> _addCategory() async {
    setState(() => _isLoading = true);
    await ref.read(dataProvider).addCourseCategory(_categoryController.text);
    final cat = ref.read(dataProvider).categories.last;
    _categoryId = cat.categoryId;
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
    _courseId = course.courseId;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Add University, Category, Course, Subject'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _universityController,
              decoration: const InputDecoration(labelText: 'University Name'),
            ),
            ElevatedButton(
              onPressed: _isLoading || _universityController.text.isEmpty
                  ? null
                  : _addUniversity,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Add University'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            ElevatedButton(
              onPressed:
                  _isLoading ||
                      _categoryController.text.isEmpty ||
                      _universityId == null
                  ? null
                  : _addCategory,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Add Category'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _courseController,
              decoration: const InputDecoration(labelText: 'Course Name'),
            ),
            ElevatedButton(
              onPressed:
                  _isLoading ||
                      _courseController.text.isEmpty ||
                      _universityId == null ||
                      _categoryId == null
                  ? null
                  : _addCourse,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Add Course'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: 'Subject Name'),
            ),
            ElevatedButton(
              onPressed:
                  _isLoading ||
                      _subjectController.text.isEmpty ||
                      _courseId == null ||
                      _universityId == null
                  ? null
                  : _addSubject,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Add Subject'),
            ),
          ],
        ),
      ),
    );
  }
}
