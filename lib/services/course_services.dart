import 'dart:io';
import 'dart:typed_data';

import '../models/course_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// ========== Courses ==========
  Future<void> addCourse(CourseModel course) async {
    await supabase.from('courses').insert(course.toMap());
  }

  Future<List<CourseModel>> fetchCourses() async {
    final response = await supabase
        .from('courses')
        .select('*, categories(*), subcategories(*)');
    return (response as List)
        .map((c) => CourseModel.fromMap(c as Map<String, dynamic>))
        .toList();
  }

  /// ========== Categories ==========
  Future<void> addCategory(String name) async {
    await supabase.from('categories').insert({'category_name': name});
  }

  Future<List<Category>> fetchCategories() async {
    final response = await supabase.from('categories').select();
    return (response as List).map((c) => Category.fromMap(c)).toList();
  }

  /// ========== Subcategories ==========
  Future<void> addSubCategory(String name, String categoryId) async {
    await supabase.from('subcategories').insert({
      'subcategory_name': name,
      'category_id': categoryId,
    });
  }

  Future<List<SubCategory>> fetchSubcategories(String categoryId) async {
    final response = await supabase
        .from('subcategories')
        .select()
        .eq('category_id', categoryId);
    return (response as List).map((s) => SubCategory.fromMap(s)).toList();
  }

  Future<List<SubCategory>> fetchAllSubcategories() async {
    final response = await supabase.from('subcategories').select();
    return (response as List).map((e) => SubCategory.fromMap(e)).toList();
  }

  /// Upload image (unchanged)
  Future<String?> uploadCourseImage({
    File? file,
    Uint8List? bytes,
    required String courseId,
    bool isWeb = false,
  }) async {
    try {
      final filePath = '$courseId.jpg';

      if (isWeb && bytes != null) {
        await supabase.storage
            .from('test-courses')
            .uploadBinary(filePath, bytes);
      } else if (file != null) {
        await supabase.storage
            .from('test-courses')
            .upload(
              filePath,
              file,
              fileOptions: const FileOptions(upsert: true),
            );
      } else {
        return null;
      }

      final publicUrl = supabase.storage
          .from('test-courses')
          .getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      return null;
    }
  }
}
