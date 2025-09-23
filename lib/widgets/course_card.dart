// lib/widgets/course_card.dart
import 'package:azeducation/models/course_model.dart';
import 'package:flutter/material.dart';


class CourseCard extends StatelessWidget {
  final CourseModel course;
  const CourseCard({super.key, required this.course});

  // Default image URL
  static const defaultImageUrl =
      "https://ubpiwzohjbeyagmnkvfx.supabase.co/storage/v1/object/public/test-courses/default_course.png";

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 100,
            width: double.infinity,
            child: Image.network(
              course.imageUrl ?? defaultImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(defaultImageUrl, fit: BoxFit.cover);
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(course.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          if (course.duration != null)
            Text("Duration: ${course.duration}", style: const TextStyle(fontSize: 14)),
          if (course.fees != null)
            Text("Fees: \$${course.fees}", style: const TextStyle(fontSize: 14)),
        ]),
      ),
    );
  }
}
