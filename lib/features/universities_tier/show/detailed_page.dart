import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:flutter/material.dart';

class CombinedCourseDetailPage extends StatelessWidget {
  final Course course;
  final List<Subject> subjects;
  final CourseDetail? courseDetail;

  const CombinedCourseDetailPage({
    super.key,
    required this.course,
    required this.subjects,
    this.courseDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.courseName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (courseDetail != null) ...[
              const Text("Course Details",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (courseDetail!.description != null)
                Text("Description: ${courseDetail!.description}"),
              if (courseDetail!.duration != null)
                Text("Duration: ${courseDetail!.duration}"),
              if (courseDetail!.fees != null)
                Text("Fees: ${courseDetail!.fees}"),
              if (courseDetail!.note1 != null)
                Text("Note1: ${courseDetail!.note1}"),
              if (courseDetail!.note2 != null)
                Text("Note2: ${courseDetail!.note2}"),
              if (courseDetail!.note3 != null)
                Text("Note3: ${courseDetail!.note3}"),
              if (courseDetail!.syllabus != null)
                Text("Syllabus: ${courseDetail!.syllabus}"),
              if (courseDetail!.imageUrl != null) ...[
                const SizedBox(height: 12),
                Image.network(courseDetail!.imageUrl!, height: 200),
              ],
              const Divider(height: 24),
            ],
            const Text("Subjects",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (subjects.isEmpty)
              const Text("No subjects available.")
            else
              ...subjects.map(
                (subject) => Card(
                  child: ListTile(
                    title: Text(subject.subjectName),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubjectDetailPage(subject: subject),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SubjectDetailPage extends StatelessWidget {
  final Subject subject;
  const SubjectDetailPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    // This page will show subject-level detail (linked from provider)
    return Scaffold(
      appBar: AppBar(title: Text(subject.subjectName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Details for ${subject.subjectName} will appear here.",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
