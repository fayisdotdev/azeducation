import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'video_class_model.dart';
import 'video_class_provider.dart';

class UploadVideoClassPage extends ConsumerStatefulWidget {
  const UploadVideoClassPage({super.key});

  @override
  ConsumerState<UploadVideoClassPage> createState() =>
      _UploadVideoClassPageState();
}

class _UploadVideoClassPageState extends ConsumerState<UploadVideoClassPage> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final supabase = Supabase.instance.client;
  final uuid = const Uuid();

  String? selectedUniversity;
  String? selectedCourse;
  String? selectedSubject;
  String? categoryName;

  List<Map<String, dynamic>> universities = [];
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> subjects = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUniversities();
  }

  Future<void> fetchUniversities() async {
    final res = await supabase
        .from('universities')
        .select('university_id, university_name') as List<dynamic>;
    setState(() => universities = res.cast<Map<String, dynamic>>());
  }

  Future<void> fetchCourses(String universityId) async {
    final res = await supabase
        .from('courses')
        .select('course_id, course_name, category_id, course_categories(category_name)')
        .eq('university_id', universityId) as List<dynamic>;
    setState(() => courses = res.cast<Map<String, dynamic>>());
  }

  Future<void> fetchSubjects(String courseId) async {
    final res = await supabase
        .from('subjects')
        .select('subject_id, subject_name')
        .eq('course_id', courseId) as List<dynamic>;
    setState(() => subjects = res.cast<Map<String, dynamic>>());
  }

  Future<void> _upload() async {
    final title = _titleController.text.trim();
    final url = _urlController.text.trim();

    if (title.isEmpty ||
        url.isEmpty ||
        selectedUniversity == null ||
        selectedCourse == null ||
        selectedSubject == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => isLoading = true);

    final universityName = universities.firstWhere(
      (u) => u['university_id'] == selectedUniversity,
    )['university_name'] as String;

    final courseData = courses.firstWhere(
      (c) => c['course_id'] == selectedCourse,
    );

    final subjectName = subjects.firstWhere(
      (s) => s['subject_id'] == selectedSubject,
    )['subject_name'] as String;

    // Get category name safely
    categoryName = courseData['course_categories'] != null
        ? courseData['course_categories']['category_name'] as String?
        : null;

    final video = VideoClassModel(
      id: uuid.v4(),
      title: title,
      videoUrl: url,
      universityId: selectedUniversity!,
      universityName: universityName,
      courseId: selectedCourse!,
      courseName: courseData['course_name'] as String,
      subjectId: selectedSubject!,
      subjectName: subjectName,
      categoryId: courseData['category_id'] as String?,
      categoryName: categoryName,
      createdAt: DateTime.now(),
    );

    await ref.read(videoClassProvider.notifier).upload(video);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video uploaded successfully')),
    );

    _titleController.clear();
    _urlController.clear();
    setState(() {
      selectedUniversity = null;
      selectedCourse = null;
      selectedSubject = null;
      categoryName = null;
      courses = [];
      subjects = [];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Video Class')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== University Dropdown =====
            DropdownButtonFormField<String>(
              value: selectedUniversity,
              hint: const Text('Select University'),
              items: universities
                  .map(
                    (u) => DropdownMenuItem<String>(
                      value: u['university_id'] as String,
                      child: Text(u['university_name'] as String),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  selectedUniversity = v;
                  selectedCourse = null;
                  selectedSubject = null;
                  courses = [];
                  subjects = [];
                  categoryName = null;
                });
                fetchCourses(v);
              },
            ),

            const SizedBox(height: 12),

            // ===== Course Dropdown =====
            DropdownButtonFormField<String>(
              value: selectedCourse,
              hint: const Text('Select Course'),
              items: courses
                  .map(
                    (c) => DropdownMenuItem<String>(
                      value: c['course_id'] as String,
                      child: Text(c['course_name'] as String),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  selectedCourse = v;
                  selectedSubject = null;
                  subjects = [];

                  final selected = courses
                      .firstWhere((c) => c['course_id'] == v, orElse: () => {});
                  categoryName = selected.isNotEmpty && selected['course_categories'] != null
                      ? selected['course_categories']['category_name'] as String?
                      : null;
                });
                fetchSubjects(v);
              },
            ),

            if (categoryName != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Category: $categoryName',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

            const SizedBox(height: 12),

            // ===== Subject Dropdown =====
            DropdownButtonFormField<String>(
              value: selectedSubject,
              hint: const Text('Select Subject'),
              items: subjects
                  .map(
                    (s) => DropdownMenuItem<String>(
                      value: s['subject_id'] as String,
                      child: Text(s['subject_name'] as String),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selectedSubject = v),
            ),

            const SizedBox(height: 12),

            // ===== Video Fields =====
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Video Title'),
            ),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'YouTube URL'),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: isLoading ? null : _upload,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Upload Video'),
            ),
          ],
        ),
      ),
    );
  }
}
