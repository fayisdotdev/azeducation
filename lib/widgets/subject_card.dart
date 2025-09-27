import 'package:flutter/material.dart';
import 'package:azeducation/features/subjects/subject_model.dart';
import 'package:azeducation/features/subjects/detailed_subject_page.dart';

class SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final void Function()? onTap;

  const SubjectCard({super.key, required this.subject, this.onTap});

  static const defaultImageUrl =
      "https://ubpiwzohjbeyagmnkvfx.supabase.co/storage/v1/object/public/test-courses/default_course.png";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailedSubjectPage(subject: subject),
            ),
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: subject.imageUrl != null
                  ? Image.network(
                      subject.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, __) =>
                          Image.network(defaultImageUrl, fit: BoxFit.cover),
                    )
                  : Image.network(defaultImageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (subject.duration != null || subject.fees != null)
                    Text(
                      "${subject.duration ?? ''}"
                      "${subject.duration != null && subject.fees != null ? " • " : ""}"
                      "${subject.fees != null ? "₹${subject.fees!.toStringAsFixed(0)}" : ""}",
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  const SizedBox(height: 6),
                  if (subject.curriculum != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${subject.curriculum} Videos",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
