import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import '../../models/course_model.dart';
import '../../providers/course_provider.dart';

class AddCoursePage extends ConsumerStatefulWidget {
  const AddCoursePage({super.key});

  @override
  ConsumerState<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends ConsumerState<AddCoursePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _feesController = TextEditingController();
  final _note1Controller = TextEditingController();
  final _note2Controller = TextEditingController();
  final _note3Controller = TextEditingController();
  final _curriculumController = TextEditingController();

  File? _pickedImage;
  Uint8List? _pickedBytes;
  bool _loading = false;

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pickedBytes = result.files.single.bytes;
        });
      }
    } else {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _pickedImage = File(picked.path);
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final courseId = const Uuid().v4();
    String? imageUrl;

    // Upload image
    imageUrl = await ref.read(courseServiceProvider).uploadCourseImage(
          file: _pickedImage,
          bytes: _pickedBytes,
          courseId: courseId,
          isWeb: kIsWeb,
        );

    final course = CourseModel(
      id: courseId,
      name: _nameController.text.trim(),
      duration: _durationController.text.trim().isEmpty ? null : _durationController.text.trim(),
      fees: _feesController.text.trim().isEmpty ? null : double.tryParse(_feesController.text.trim()),
      note1: _note1Controller.text.trim().isEmpty ? null : _note1Controller.text.trim(),
      note2: _note2Controller.text.trim().isEmpty ? null : _note2Controller.text.trim(),
      note3: _note3Controller.text.trim().isEmpty ? null : _note3Controller.text.trim(),
      curriculum: _curriculumController.text.trim().isEmpty ? null : _curriculumController.text.trim(),
      imageUrl: imageUrl,
    );

    try {
      await ref.read(courseServiceProvider).addCourse(course);
      ref.invalidate(courseListProvider); // Refresh list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Course added successfully")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add course: $e")));
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Course")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: kIsWeb
                        ? (_pickedBytes != null
                            ? Image.memory(_pickedBytes!, fit: BoxFit.cover)
                            : const Icon(Icons.add_a_photo, size: 50))
                        : (_pickedImage != null
                            ? Image.file(_pickedImage!, fit: BoxFit.cover)
                            : const Icon(Icons.add_a_photo, size: 50)),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Course Name *"),
                  validator: (value) => value == null || value.isEmpty ? "Name is required" : null,
                ),
                TextFormField(controller: _durationController, decoration: const InputDecoration(labelText: "Duration")),
                TextFormField(controller: _feesController, decoration: const InputDecoration(labelText: "Fees"), keyboardType: TextInputType.number),
                TextFormField(controller: _note1Controller, decoration: const InputDecoration(labelText: "Note 1")),
                TextFormField(controller: _note2Controller, decoration: const InputDecoration(labelText: "Note 2")),
                TextFormField(controller: _note3Controller, decoration: const InputDecoration(labelText: "Note 3")),
                TextFormField(controller: _curriculumController, decoration: const InputDecoration(labelText: "Curriculum")),
                const SizedBox(height: 20),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(onPressed: _submit, child: const Text("Add Course")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
