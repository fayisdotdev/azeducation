import 'package:flutter/material.dart';
import '../models/course_model.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final void Function()? onTap;

  const CourseCard({super.key, required this.course, this.onTap});

  static const defaultImageUrl =
      "https://ubpiwzohjbeyagmnkvfx.supabase.co/storage/v1/object/public/test-courses/default_course.png";

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.of(context).size.width - 12 * 3) / 2;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            AspectRatio(
              aspectRatio: 16 / 9, // keeps images proportional
              child: Image.network(
                course.imageUrl ?? defaultImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) =>
                    Image.network(defaultImageUrl, fit: BoxFit.cover),
              ),
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course name
                  Text(
                    course.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Category + Subcategory
                  if (course.categoryName != null)
                    Text(
                      "${course.categoryName} • ${course.subcategoryName ?? ''}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 6),

                  // Duration + Fees
                  if (course.duration != null || course.fees != null)
                    Text(
                      "${course.duration ?? ''}"
                      "${course.duration != null && course.fees != null ? " • " : ""}"
                      "${course.fees != null ? "₹${course.fees!.toStringAsFixed(0)}" : ""}",
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),

                  const SizedBox(height: 6),

                  // Curriculum
                  if (course.curriculum != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${course.curriculum} Videos",
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
