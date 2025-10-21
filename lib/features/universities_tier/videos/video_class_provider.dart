import 'package:azeducation/features/universities_tier/videos/video_class_model.dart';
import 'package:azeducation/features/universities_tier/videos/video_class_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';


final videoClassProvider = StateNotifierProvider<VideoClassNotifier, AsyncValue<List<VideoClassModel>>>(
  (ref) => VideoClassNotifier(),
);

class VideoClassNotifier extends StateNotifier<AsyncValue<List<VideoClassModel>>> {
  final _service = VideoClassService();

  VideoClassNotifier() : super(const AsyncValue.loading()) {
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      final videos = await _service.fetchAll();
      state = AsyncValue.data(videos);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> upload(VideoClassModel video) async {
    await _service.uploadVideo(video);
    fetchVideos();
  }
}
