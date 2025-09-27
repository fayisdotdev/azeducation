import 'dart:io';
import 'dart:typed_data';

import 'package:azeducation/features/subjects/subject_model.dart';
import 'package:azeducation/features/subjects/subject_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

class AddSubjectPage extends ConsumerStatefulWidget {
  const AddSubjectPage({super.key});

  @override
  ConsumerState<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends ConsumerState<AddSubjectPage> {
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

  String? _selectedStageId;
  String? _selectedClassId;

  /// Pick image (web or mobile)
  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() => _pickedBytes = result.files.single.bytes);
      }
    } else {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => _pickedImage = File(picked.path));
      }
    }
  }

  /// Submit form
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStageId == null || _selectedClassId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select stage and class")),
      );
      return;
    }

    setState(() => _loading = true);

    final subjectId = const Uuid().v4();

    try {
      // Upload image if exists
      final imageUrl = await ref.read(subjectServiceProvider).uploadSubjectImage(
            file: _pickedImage,
            bytes: _pickedBytes,
            subjectId: subjectId,
            isWeb: kIsWeb,
          );

      final newSubject = SubjectModel(
        id: subjectId,
        name: _nameController.text.trim(),
        stageId: _selectedStageId!,
        classId: _selectedClassId!,
        duration: _durationController.text.trim().isEmpty
            ? null
            : _durationController.text.trim(),
        fees: _feesController.text.trim().isEmpty
            ? null
            : double.tryParse(_feesController.text.trim()),
        note1: _note1Controller.text.trim().isEmpty
            ? null
            : _note1Controller.text.trim(),
        note2: _note2Controller.text.trim().isEmpty
            ? null
            : _note2Controller.text.trim(),
        note3: _note3Controller.text.trim().isEmpty
            ? null
            : _note3Controller.text.trim(),
        curriculum: _curriculumController.text.trim().isEmpty
            ? null
            : _curriculumController.text.trim(),
        imageUrl: imageUrl,
      );

      await ref.read(subjectServiceProvider).addSubject(newSubject);

      // Refresh subjects for the selected class
      ref.invalidate(subjectListByClassProvider(_selectedClassId!));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Subject added successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e, st) {
      debugPrint("❌ Failed to add subject: $e\n$st");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add subject: $e")),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Subject")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // IMAGE PICKER
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

                // STAGE DROPDOWN
                Consumer(
                  builder: (context, ref, _) {
                    final asyncStages = ref.watch(stageListProvider);
                    return asyncStages.when(
                      data: (stages) => DropdownButtonFormField<String>(
                        value: _selectedStageId,
                        decoration: const InputDecoration(labelText: "Stage *"),
                        items: stages
                            .map(
                              (s) => DropdownMenuItem(
                                value: s.stageId,
                                child: Text(s.stageName),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedStageId = val;
                            _selectedClassId = null;
                          });
                        },
                        validator: (val) =>
                            val == null ? "Stage is required" : null,
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (e, _) => Text("Error loading stages: $e"),
                    );
                  },
                ),

                // CLASS DROPDOWN
                if (_selectedStageId != null)
                  Consumer(
                    builder: (context, ref, _) {
                      final asyncClasses =
                          ref.watch(classListProvider(_selectedStageId!));
                      return asyncClasses.when(
                        data: (classes) => DropdownButtonFormField<String>(
                          value: _selectedClassId,
                          decoration: const InputDecoration(labelText: "Class *"),
                          items: classes
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c.classId,
                                  child: Text(c.className),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => setState(() => _selectedClassId = val),
                          validator: (val) =>
                              val == null ? "Class is required" : null,
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Text("Error loading classes: $e"),
                      );
                    },
                  ),

                const SizedBox(height: 10),

                // SUBJECT DETAILS
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Subject Name *"),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Name is required" : null,
                ),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(labelText: "Duration"),
                ),
                TextFormField(
                  controller: _feesController,
                  decoration: const InputDecoration(labelText: "Fees"),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _note1Controller,
                  decoration: const InputDecoration(labelText: "Note 1"),
                ),
                TextFormField(
                  controller: _note2Controller,
                  decoration: const InputDecoration(labelText: "Note 2"),
                ),
                TextFormField(
                  controller: _note3Controller,
                  decoration: const InputDecoration(labelText: "Note 3"),
                ),
                TextFormField(
                  controller: _curriculumController,
                  decoration: const InputDecoration(labelText: "Curriculum"),
                ),
                const SizedBox(height: 20),

                // SUBMIT BUTTON
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit, child: const Text("Add Subject")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
