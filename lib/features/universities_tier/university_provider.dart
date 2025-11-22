import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:azeducation/features/universities_tier/university_services.dart';
import 'package:flutter/foundation.dart';

class DataProvider extends ChangeNotifier {
  final DatabaseService _service = DatabaseService();

  // ===== Data Lists =====
  List<University> universities = [];
  List<CourseCategory> categories = [];
  List<Course> courses = [];
  List<Subject> subjects = [];
  List<CourseDetail> courseDetails = [];

  bool isLoading = false;
  bool hasLoaded = false; // prevents reloading every time

  // ===== Fetch All Data with relational linking =====
  Future<void> fetchAll({bool forceRefresh = false}) async {
    if (hasLoaded && !forceRefresh) return;

    isLoading = true;
    notifyListeners();

    try {
      // fetch raw data
      universities = await _service.getUniversities();
      categories = await _service.getCourseCategories();
      courses = await _service.getCourses();
      subjects = await _service.getSubjects();
      courseDetails = await _service.getCourseDetails();

      // ===== LINK RELATIONS =====

      // Link university & category to courses
      for (var course in courses) {
        course.university =
            universities
                .where((u) => u.universityId == course.universityId)
                .isNotEmpty
            ? universities.firstWhere(
                (u) => u.universityId == course.universityId,
              )
            : null;

        course.category =
            categories
                .where((c) => c.categoryId == course.categoryId)
                .isNotEmpty
            ? categories.firstWhere((c) => c.categoryId == course.categoryId)
            : null;

        // link subjects and courseDetails to course
        course.subjects = subjects
            .where((s) => s.courseId == course.courseId)
            .map((s) {
              s.course = course; // link course to subject
              s.university = course.university; // link university to subject
              return s;
            })
            .toList();

        course.courseDetails = courseDetails
            .where((d) => d.courseId == course.courseId)
            .map((d) {
              d.course = course;
              d.university = course.university;
              if (d.subjectId != null) {
                d.subject =
                    course.subjects
                        .where((s) => s.subjectId == d.subjectId)
                        .isNotEmpty
                    ? course.subjects.firstWhere(
                        (s) => s.subjectId == d.subjectId,
                      )
                    : null;
              }
              return d;
            })
            .toList();
      }

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
