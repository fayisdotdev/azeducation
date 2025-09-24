import 'package:azeducation/models/course_model.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final void Function()? onTap;

  const CourseCard({super.key, required this.course, this.onTap});

  static const defaultImageUrl =
      "https://ubpiwzohjbeyagmnkvfx.supabase.co/storage/v1/object/public/test-courses/default_course.png";

  @override
  Widget build(BuildContext context) {
    // Calculate card width based on screen size
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
            // Top image (responsive height)
            SizedBox(
              height: cardWidth * 0.6, // 60% of card width
              width: double.infinity,
              child: Image.network(
                course.imageUrl ?? defaultImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.network(defaultImageUrl, fit: BoxFit.cover),
              ),
            ),

            // Bottom container for text and badges
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.white,
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
                  const SizedBox(height: 8),

                  // // Duration on separate line
                  // if (course.duration != null)
                  //   Container(
                  //     margin: const EdgeInsets.only(bottom: 4),
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 8, vertical: 4),
                  //     decoration: BoxDecoration(
                  //       color: Colors.blue.shade100,
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: Text(
                  //       "Duration: ${course.duration!}",
                  //       style: const TextStyle(
                  //           fontSize: 12, fontWeight: FontWeight.w500),
                  //     ),
                  //   ),

                  // Fees on separate line
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
