import 'package:azeducation/features/universities_tier/videos/video_class_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoClassStreamPage extends ConsumerWidget {
  const VideoClassStreamPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videos = ref.watch(videoClassProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Video Classes')),
      body: videos.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            final v = data[i];
            final videoId = YoutubePlayer.convertUrlToId(v.videoUrl) ?? '';

            return Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${v.universityName} • ${v.courseName}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${v.subjectName} (${v.categoryName ?? "No category"})',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      v.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    if (videoId.isNotEmpty)
                      YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: videoId,
                          flags: const YoutubePlayerFlags(autoPlay: false),
                        ),
                        showVideoProgressIndicator: true,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (e, _) => Center(child: Text('Error loading videos: $e')),
      ),
    );
  }
}
