import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:flutter/material.dart';

class CourseDetailPage extends StatelessWidget {
  final CourseDetail detail;
  const CourseDetailPage({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Course / Subject Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (detail.description != null)
              Text("Description: ${detail.description}"),
            if (detail.duration != null) Text("Duration: ${detail.duration}"),
            if (detail.fees != null) Text("Fees: ${detail.fees}"),
            if (detail.note1 != null) Text("Note1: ${detail.note1}"),
            if (detail.note2 != null) Text("Note2: ${detail.note2}"),
            if (detail.note3 != null) Text("Note3: ${detail.note3}"),
            if (detail.syllabus != null) Text("Syllabus: ${detail.syllabus}"),
            if (detail.imageUrl != null)
              Image.network(detail.imageUrl!, height: 200),
          ],
        ),
      ),
    );
  }
}
