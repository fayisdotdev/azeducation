import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course_model.dart';

class CourseService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> addCourse(CourseModel course) async {
    await supabase.from('courses').insert(course.toMap());
  }

  Future<List<CourseModel>> fetchCourses() async {
    final response = await supabase.from('courses').select();
    debugPrint("Raw courses response: $response"); // debug
    return (response as List)
        .map((c) => CourseModel.fromMap(c as Map<String, dynamic>))
        .toList();
  }

  /// Upload image to Supabase Storage
  Future<String?> uploadCourseImage({File? file, Uint8List? bytes, required String courseId, bool isWeb = false}) async {
    try {
      final filePath = '$courseId.jpg';

      if (isWeb && bytes != null) {
        await supabase.storage.from('test-courses').uploadBinary(filePath, bytes);
      } else if (file != null) {
        await supabase.storage.from('test-courses').upload(filePath, file, fileOptions: const FileOptions(upsert: true));
      } else {
        return null;
      }

      final publicUrl = supabase.storage.from('test-courses').getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return null;
    }
  }
}
