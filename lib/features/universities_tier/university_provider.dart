import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:azeducation/features/universities_tier/university_services.dart';
import 'package:flutter/foundation.dart';

class DataProvider extends ChangeNotifier {
  final DatabaseService _service = DatabaseService();

  // ===== Data Lists =====
  List<University> universities = [];
  List<Course> courses = [];
  List<CourseCategory> categories = [];
  List<Subject> subjects = [];
  List<CourseDetail> courseDetails = [];

  bool isLoading = false;
  bool hasLoaded = false; // 🔥 prevents reloading every time

  // ===== Fetch All Data =====
  Future<void> fetchAll({bool forceRefresh = false}) async {
    // ✅ If data is already loaded and no forceRefresh requested, skip reload
    if (hasLoaded && !forceRefresh) return;

    isLoading = true;
    notifyListeners();

    try {
      universities = await _service.getUniversities();
      courses = await _service.getCourses();
      categories = await _service.getCourseCategories();
      subjects = await _service.getSubjects();
      courseDetails = await _service.getCourseDetails();

      hasLoaded = true;
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // ====== Universities =====

  Future<void> addUniversity(String name, {String? classifications}) async {
    await _service.addUniversity(name, classifications: classifications);
    await fetchAll(forceRefresh: true);
  }

  Future<void> updateUniversity(
    String id,
    String name, {
    String? classifications,
  }) async {
    await _service.updateUniversity(id, name, classifications: classifications);
    await fetchAll(forceRefresh: true);
  }

  Future<void> deleteUniversity(String id) async {
    await _service.deleteUniversity(id);
    await fetchAll(forceRefresh: true);
  }

  // ====== Courses =====
  Future<void> addCourse(
    String uniId,
    String name, {
    String? categoryId,
  }) async {
    await _service.addCourse(uniId, name, categoryId: categoryId);
    await fetchAll(forceRefresh: true);
  }

  Future<void> updateCourse(
    String id,
    String name, {
    String? categoryId,
  }) async {
    await _service.updateCourse(id, name, categoryId: categoryId);
    await fetchAll(forceRefresh: true);
  }

  Future<void> deleteCourse(String id) async {
    await _service.deleteCourse(id);
    await fetchAll(forceRefresh: true);
  }

  // ====== Course Categories =====
  Future<void> addCourseCategory(String name) async {
    await _service.addCourseCategory(name);
    await fetchAll(forceRefresh: true);
  }

  Future<void> updateCourseCategory(String id, String name) async {
    await _service.updateCourseCategory(id, name);
    await fetchAll(forceRefresh: true);
  }

  Future<void> deleteCourseCategory(String id) async {
    await _service.deleteCourseCategory(id);
    await fetchAll(forceRefresh: true);
  }

  // ====== Subjects =====
  Future<void> addSubject(String courseId, String uniId, String name) async {
    await _service.addSubject(courseId, uniId, name);
    await fetchAll(forceRefresh: true);
  }

  Future<void> updateSubject(String id, String name) async {
    await _service.updateSubject(id, name);
    await fetchAll(forceRefresh: true);
  }

  Future<void> deleteSubject(String id) async {
    await _service.deleteSubject(id);
    await fetchAll(forceRefresh: true);
  }

  // ====== Course Details =====
  Future<void> addCourseDetail(CourseDetail detail) async {
    await _service.addCourseDetail(detail);
    await fetchAll(forceRefresh: true);
  }

  Future<void> updateCourseDetail(String id, Map<String, dynamic> data) async {
    await _service.updateCourseDetail(id, data);
    await fetchAll(forceRefresh: true);
  }

  Future<void> deleteCourseDetail(String id) async {
    await _service.deleteCourseDetail(id);
    await fetchAll(forceRefresh: true);
  }
}
