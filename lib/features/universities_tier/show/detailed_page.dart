import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:azeducation/features/universities_tier/videos/video_class_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ----- Combined Course Detail Page -----
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
            // Course Details
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

            // Subjects
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
                      // Navigate to Subject Detail Page
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

// ----- Subject Detail Page -----
class SubjectDetailPage extends ConsumerWidget {
  final Subject subject;

  const SubjectDetailPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videos = ref.watch(videoClassProvider);

    // Filter videos for this subject
    final subjectVideos = videos.maybeWhen(
      data: (list) =>
          list.where((v) => v.subjectId == subject.subjectId).toList(),
      orElse: () => [],
    );

    return Scaffold(
      appBar: AppBar(title: Text(subject.subjectName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Subject Details (placeholder or from your model)
            Text(
              "Details for ${subject.subjectName} will appear here.",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Videos for this subject
            if (subjectVideos.isEmpty)
              const Text("No videos available for this subject.")
            else ...subjectVideos.map(
              (video) {
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
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('${video.courseName} • ${video.universityName}'),
                        const SizedBox(height: 4),
                        if (video.categoryName != null)
                          Text('Category: ${video.categoryName}'),
                        if (videoId.isNotEmpty)
                          YoutubePlayer(
                            controller: YoutubePlayerController(
                              initialVideoId: videoId,
                              flags: const YoutubePlayerFlags(autoPlay: false),
                            ),
                          ),
                      ],
                    ),
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
