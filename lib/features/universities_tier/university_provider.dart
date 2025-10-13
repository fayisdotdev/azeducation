// provider.dart

import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:azeducation/features/universities_tier/university_services.dart';
import 'package:flutter/foundation.dart';

class DataProvider extends ChangeNotifier {
  final DatabaseService _service = DatabaseService();

  // ===== Data Lists =====
  List<University> universities = [];
  List<Course> courses = [];
  List<CourseCategory> categories = []; // new
  List<Subject> subjects = [];
  List<CourseDetail> courseDetails = [];

  bool isLoading = false;

  // ===== Fetch All Data =====
  Future<void> fetchAll() async {
    isLoading = true;
    notifyListeners();

    universities = await _service.getUniversities();
    courses = await _service.getCourses();
    categories = await _service.getCourseCategories(); // fetch categories
    subjects = await _service.getSubjects();
    courseDetails = await _service.getCourseDetails();

    isLoading = false;
    notifyListeners();
  }

  // ====== Universities =====
  Future<void> addUniversity(String name) async {
    await _service.addUniversity(name);
    await fetchAll();
  }

  Future<void> updateUniversity(String id, String name) async {
    await _service.updateUniversity(id, name);
    await fetchAll();
  }

  Future<void> deleteUniversity(String id) async {
    await _service.deleteUniversity(id);
    await fetchAll();
  }

  // ====== Courses =====
  Future<void> addCourse(String uniId, String name, {String? categoryId}) async {
    await _service.addCourse(uniId, name, categoryId: categoryId);
    await fetchAll();
  }

  Future<void> updateCourse(String id, String name, {String? categoryId}) async {
    await _service.updateCourse(id, name, categoryId: categoryId);
    await fetchAll();
  }

  Future<void> deleteCourse(String id) async {
    await _service.deleteCourse(id);
    await fetchAll();
  }

  // ====== Course Categories =====
  Future<void> addCourseCategory(String name) async {
    await _service.addCourseCategory(name);
    await fetchAll();
  }

  Future<void> updateCourseCategory(String id, String name) async {
    await _service.updateCourseCategory(id, name);
    await fetchAll();
  }

  Future<void> deleteCourseCategory(String id) async {
    await _service.deleteCourseCategory(id);
    await fetchAll();
  }

  // ====== Subjects =====
  Future<void> addSubject(String courseId, String uniId, String name) async {
    await _service.addSubject(courseId, uniId, name);
    await fetchAll();
  }

  Future<void> updateSubject(String id, String name) async {
    await _service.updateSubject(id, name);
    await fetchAll();
  }

  Future<void> deleteSubject(String id) async {
    await _service.deleteSubject(id);
    await fetchAll();
  }

  // ====== Course Details =====
  Future<void> addCourseDetail(CourseDetail detail) async {
    await _service.addCourseDetail(detail);
    await fetchAll();
  }

  Future<void> updateCourseDetail(String id, Map<String, dynamic> data) async {
    await _service.updateCourseDetail(id, data);
    await fetchAll();
  }

  Future<void> deleteCourseDetail(String id) async {
    await _service.deleteCourseDetail(id);
    await fetchAll();
  }
}
