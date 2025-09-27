import 'package:flutter/material.dart';
import 'package:azeducation/features/subjects/subject_model.dart';

class DetailedSubjectPage extends StatelessWidget {
  final SubjectModel subject;

  const DetailedSubjectPage({super.key, required this.subject});

  static const defaultImageUrl =
      "https://ubpiwzohjbeyagmnkvfx.supabase.co/storage/v1/object/public/test-courses/default_course.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: subject.imageUrl != null
                  ? Image.network(
                      subject.imageUrl!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, __) =>
                          Image.network(defaultImageUrl, fit: BoxFit.cover),
                    )
                  : Image.network(defaultImageUrl, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              subject.name,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Stage & Class
            if (subject.stageName != null)
              Text(
                "${subject.stageName} • ${subject.className ?? ''}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            const SizedBox(height: 12),

            // Duration & Fees
            if (subject.duration != null || subject.fees != null)
              Text(
                "${subject.duration ?? ''}"
                "${subject.duration != null && subject.fees != null ? " • " : ""}"
                "${subject.fees != null ? "₹${subject.fees!.toStringAsFixed(0)}" : ""}",
                style: const TextStyle(fontSize: 14),
              ),
            const SizedBox(height: 12),

            // Notes
            if (subject.note1 != null)
              Text("📌 ${subject.note1!}",
                  style: const TextStyle(fontSize: 14)),
            if (subject.note2 != null)
              Text("📌 ${subject.note2!}",
                  style: const TextStyle(fontSize: 14)),
            if (subject.note3 != null)
              Text("📌 ${subject.note3!}",
                  style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),

            // Curriculum
            if (subject.curriculum != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${subject.curriculum} Videos",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
