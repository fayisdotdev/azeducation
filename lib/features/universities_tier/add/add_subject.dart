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
  Widget build(BuildContext context) {
    final provider = ref.watch(dataProvider);

    final coursesForSelectedUni = provider.courses
        .where((c) => c.universityId == selectedUniversityId)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text("Add Subject")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedUniversityId,
              hint: Text("Select University"),
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
            DropdownButtonFormField<String>(
              value: selectedCourseId,
              hint: Text("Select Course"),
              items: coursesForSelectedUni
                  .map((c) => DropdownMenuItem(
                        value: c.courseId,
                        child: Text(c.courseName),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => selectedCourseId = val),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Subject Name"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (selectedUniversityId != null &&
                    selectedCourseId != null &&
                    _controller.text.isNotEmpty) {
                  await ref
                      .read(dataProvider)
                      .addSubject(selectedCourseId!, selectedUniversityId!, _controller.text);
                  Navigator.pop(context);
                }
              },
              child: provider.isLoading
                  ? CircularProgressIndicator()
                  : Text("Add Subject"),
            ),
          ],
        ),
      ),
    );
  }
}
