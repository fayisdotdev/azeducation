import 'package:azeducation/models/course_model.dart';
import 'package:flutter/material.dart';

class DetailedCoursePage extends StatelessWidget {
  final CourseModel course;

  const DetailedCoursePage({super.key, required this.course});

  static const defaultImageUrl =
      "https://ubpiwzohjbeyagmnkvfx.supabase.co/storage/v1/object/public/test-courses/default_course.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
            ClipRRect(
              
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                course.imageUrl ?? defaultImageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) =>
                    Image.network(defaultImageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              course.name,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Category & Subcategory
            if (course.categoryName != null)
              Text(
                "${course.categoryName} • ${course.subcategoryName ?? ''}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            const SizedBox(height: 12),

            // Duration & Fees
            if (course.duration != null || course.fees != null)
              Text(
                "${course.duration ?? ''}"
                "${course.duration != null && course.fees != null ? " Months " : ""}\n"
                "${course.fees != null ? "₹${course.fees!.toStringAsFixed(0)} Fees" : ""}",
                style: const TextStyle(fontSize: 14),
              ),
            const SizedBox(height: 12),

            // Notes
            if (course.note1 != null)
              Text("📌 ${course.note1!}",
                  style: const TextStyle(fontSize: 14)),
            if (course.note2 != null)
              Text("📌 ${course.note2!}",
                  style: const TextStyle(fontSize: 14)),
            if (course.note3 != null)
              Text("📌 ${course.note3!}",
                  style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),

            // Curriculum
            if (course.curriculum != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${course.curriculum} Videos",
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
