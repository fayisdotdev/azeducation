// services.dart

import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final supabase = Supabase.instance.client;

class DatabaseService {
    // final supabase = Supabase.instance.client;

  // ===== UNIVERSITIES =====
  Future<List<University>> getUniversities() async {
    final res = await supabase.from('universities').select();
    return res.map((e) => University.fromJson(e)).toList().cast<University>();
  }

Future<void> addUniversity(String name, List<String> categoryIds) async {
  await supabase.from('universities').insert({
    'university_name': name,
    'category_ids': categoryIds, // store multiple categories
    'created_at': DateTime.now().toIso8601String(),
  });
}

Future<void> updateUniversity(String id, String newName, List<String> categoryIds) async {
  await supabase
      .from('universities')
      .update({
        'university_name': newName,
        'category_ids': categoryIds, // update multi-categories
      })
      .eq('university_id', id);
}


  Future<void> deleteUniversity(String id) async {
    await supabase.from('universities').delete().eq('university_id', id);
  }

// ===== COURSE CATEGORIES =====
  Future<List<CourseCategory>> getCourseCategories() async {
    final res = await supabase.from('course_categories').select();
    return res.map((e) => CourseCategory.fromJson(e)).toList().cast<CourseCategory>();
  }

  Future<void> addCourseCategory(String name) async {
    await supabase.from('course_categories').insert({'category_name': name});
  }

  Future<void> updateCourseCategory(String id, String name) async {
    await supabase
        .from('course_categories')
        .update({'category_name': name})
        .eq('category_id', id);
  }

  Future<void> deleteCourseCategory(String id) async {
    await supabase.from('course_categories').delete().eq('category_id', id);
  }

  // ===== COURSES =====
  Future<List<Course>> getCourses() async {
    final res = await supabase.from('courses').select();
    return res.map((e) => Course.fromJson(e)).toList().cast<Course>();
  }

  Future<void> addCourse(String universityId, String name, {String? categoryId}) async {
    await supabase.from('courses').insert({
      'university_id': universityId,
      'course_name': name,
      'category_id': categoryId, // optional
    });
  }

  Future<void> updateCourse(String id, String name, {String? categoryId}) async {
    await supabase
        .from('courses')
        .update({
          'course_name': name,
          'category_id': categoryId,
        })
        .eq('course_id', id);
  }

  Future<void> deleteCourse(String id) async {
    await supabase.from('courses').delete().eq('course_id', id);
  }


  // ===== SUBJECTS =====
  Future<List<Subject>> getSubjects() async {
    final res = await supabase.from('subjects').select();
    return res.map((e) => Subject.fromJson(e)).toList().cast<Subject>();
  }

  Future<void> addSubject(
      String courseId, String universityId, String name) async {
    await supabase.from('subjects').insert({
      'course_id': courseId,
      'university_id': universityId,
      'subject_name': name,
    });
  }

  Future<void> updateSubject(String id, String newName) async {
    await supabase
        .from('subjects')
        .update({'subject_name': newName})
        .eq('subject_id', id);
  }

  Future<void> deleteSubject(String id) async {
    await supabase.from('subjects').delete().eq('subject_id', id);
  }

  // ===== COURSE DETAILS =====
  Future<List<CourseDetail>> getCourseDetails() async {
    final res = await supabase.from('course_details').select();
    return res.map((e) => CourseDetail.fromJson(e)).toList().cast<CourseDetail>();
  }

  Future<void> addCourseDetail(CourseDetail detail) async {
    await supabase.from('course_details').insert(detail.toJson());
  }

  Future<void> updateCourseDetail(String id, Map<String, dynamic> data) async {
    await supabase.from('course_details').update(data).eq('detail_id', id);
  }

  Future<void> deleteCourseDetail(String id) async {
    await supabase.from('course_details').delete().eq('detail_id', id);
  }

  
}
