import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:azeducation/features/universities_tier/videos/video_class_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CombinedCourseDetailPage extends StatelessWidget {
  final Course course;
  final List<Subject> subjects;
  final List<CourseDetail> courseDetails; // both course & subject-level

  const CombinedCourseDetailPage({
    super.key,
    required this.course,
    required this.subjects,
    required this.courseDetails,
  });

  @override
  Widget build(BuildContext context) {
    // course-level detail (subjectId == null)
    CourseDetail? courseDetail;
    try {
      courseDetail = courseDetails.firstWhere(
        (d) => d.courseId == course.courseId && d.subjectId == null,
      );
    } on StateError {
      // no matching course-level detail
      courseDetail = null;
    }

    return Scaffold(
      appBar: AppBar(title: Text(course.courseName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ----- Course-level Details -----
            if (courseDetail != null) ...[
              const Text("Course Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (courseDetail.description != null)
                Text("Description: ${courseDetail.description}"),
              if (courseDetail.duration != null)
                Text("Duration: ${courseDetail.duration}"),
              if (courseDetail.fees != null) Text("Fees: ${courseDetail.fees}"),
              if (courseDetail.note1 != null)
                Text("Note1: ${courseDetail.note1}"),
              if (courseDetail.note2 != null)
                Text("Note2: ${courseDetail.note2}"),
              if (courseDetail.note3 != null)
                Text("Note3: ${courseDetail.note3}"),
              if (courseDetail.syllabus != null)
                Text("Syllabus: ${courseDetail.syllabus}"),
              if (courseDetail.imageUrl != null) ...[
                const SizedBox(height: 12),
                Image.network(courseDetail.imageUrl!, height: 200),
              ],
              const Divider(height: 24),
            ],

            // ----- Subjects -----
            const Text("Subjects",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (subjects.isEmpty)
              const Text("No subjects available.")
            else
              ...subjects.map(
                (subject) {
                  // subject-specific detail or fallback to courseDetail
                  CourseDetail? detail;
                  try {
                    detail = courseDetails.firstWhere(
                      (d) => d.subjectId == subject.subjectId,
                    );
                  } catch (_) {
                    detail = courseDetail;
                  }

                  return Card(
                    child: ListTile(
                      title: Text(subject.subjectName),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubjectDetailPage(
                              subject: subject,
                              courseDetail: detail,
                              allCourseDetails: courseDetails,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}


// ----- SubjectDetailPage -----
class SubjectDetailPage extends ConsumerWidget {
  final Subject subject;
  final CourseDetail? courseDetail;
  final List<CourseDetail> allCourseDetails;

  const SubjectDetailPage({
    super.key,
    required this.subject,
    this.courseDetail,
    required this.allCourseDetails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videos = ref.watch(videoClassProvider);

    // Filter videos for this subject
    final subjectVideos = videos.maybeWhen(
      data: (list) =>
          list.where((v) => v.subjectId == subject.subjectId).toList(),
      orElse: () => [],
    );

    // Merge course-level details if subject details are missing fields
    CourseDetail? mergedDetail = courseDetail;
    if (courseDetail != null && courseDetail!.subjectId != subject.subjectId) {
      // fallback: subjectDetail missing? try to find subject-specific detail
      mergedDetail = allCourseDetails.firstWhere(
        (d) => d.subjectId == subject.subjectId,
        orElse: () => courseDetail!,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(subject.subjectName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ----- Subject Info -----
            const Text("Subject Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Name: ${subject.subjectName}"),
            const SizedBox(height: 16),

            // ----- Details from course_details -----
            if (mergedDetail != null) ...[
              const Text("Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (mergedDetail.description != null)
                Text("Description: ${mergedDetail.description}"),
              if (mergedDetail.duration != null)
                Text("Duration: ${mergedDetail.duration}"),
              if (mergedDetail.fees != null) Text("Fees: ${mergedDetail.fees}"),
              if (mergedDetail.note1 != null) Text("Note1: ${mergedDetail.note1}"),
              if (mergedDetail.note2 != null) Text("Note2: ${mergedDetail.note2}"),
              if (mergedDetail.note3 != null) Text("Note3: ${mergedDetail.note3}"),
              if (mergedDetail.syllabus != null)
                Text("Syllabus: ${mergedDetail.syllabus}"),
              if (mergedDetail.imageUrl != null) ...[
                const SizedBox(height: 12),
                Image.network(mergedDetail.imageUrl!, height: 200),
              ],
              const Divider(height: 24),
            ],

            // ----- Videos -----
            const Text("Videos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            videos.when(
              data: (_) {
                if (subjectVideos.isEmpty) {
                  return const Text("No videos available for this subject.");
                }

                return Column(
                  children: subjectVideos.map((video) {
                    final videoId =
                        YoutubePlayer.convertUrlToId(video.videoUrl) ?? '';
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(video.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('${video.courseName} • ${video.universityName}'),
                            const SizedBox(height: 4),
                            if (video.categoryName != null)
                              Text('Category: ${video.categoryName}'),
                            if (videoId.isNotEmpty)
                              YoutubePlayer(
                                controller: YoutubePlayerController(
                                  initialVideoId: videoId,
                                  flags:
                                      const YoutubePlayerFlags(autoPlay: false),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error loading videos: $e')),
            ),
          ],
        ),
      ),
    );
  }
}
