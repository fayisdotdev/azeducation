import 'package:azeducation/features/universities_tier/videos/video_class_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VideoClassService {
  final supabase = Supabase.instance.client;

  Future<void> uploadVideo(VideoClassModel video) async {
    await supabase.from('video_classes').insert(video.toJson());
  }

  Future<List<VideoClassModel>> fetchAll() async {
    final response = await supabase
        .from('video_classes')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => VideoClassModel.fromJson(json))
        .toList();
  }
}
