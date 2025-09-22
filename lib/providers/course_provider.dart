import 'package:azeducation/services/course_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_model.dart';

final courseServiceProvider = Provider<CourseService>((ref) => CourseService());

// FutureProvider that can be invalidated after adding a course
final courseListProvider = FutureProvider<List<CourseModel>>((ref) async {
  return ref.read(courseServiceProvider).fetchCourses();
});
