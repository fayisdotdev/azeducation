import 'package:azeducation/features/universities_tier/add/add_university.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCourseDetailPage extends ConsumerStatefulWidget {
  final String courseId;
  final String universityId;

  const AddCourseDetailPage({super.key, required this.courseId, required this.universityId});

  @override
  ConsumerState<AddCourseDetailPage> createState() => _AddCourseDetailPageState();
}

class _AddCourseDetailPageState extends ConsumerState<AddCourseDetailPage> {
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _feesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Add Course Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(labelText: "Duration"),
            ),
            TextField(
              controller: _feesController,
              decoration: InputDecoration(labelText: "Fees"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final detail = CourseDetail(
                  detailId: uuid.v4(),
                  courseId: widget.courseId,
                  universityId: widget.universityId,
                  createdAt: DateTime.now(),
                  description: _descriptionController.text,
                  duration: _durationController.text,
                  fees: num.tryParse(_feesController.text),
                );
                await ref.read(dataProvider).addCourseDetail(detail);
                Navigator.pop(context);
              },
              child: provider.isLoading
                  ? CircularProgressIndicator()
                  : Text("Add Details"),
            ),
          ],
        ),
      ),
    );
  }
}
