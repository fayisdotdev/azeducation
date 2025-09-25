import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_model.dart';
import '../services/course_services.dart';

final courseServiceProvider = Provider<CourseService>((ref) => CourseService());

final courseListProvider = FutureProvider<List<CourseModel>>((ref) async {
  return ref.read(courseServiceProvider).fetchCourses();
});

final categoryListProvider = FutureProvider<List<Category>>((ref) async {
  return ref.read(courseServiceProvider).fetchCategories();
});

final subCategoryListProvider =
    FutureProvider.family<List<SubCategory>, String>((ref, categoryId) async {
  return ref.read(courseServiceProvider).fetchSubcategories(categoryId);
});

final allSubCategoriesProvider = FutureProvider<List<SubCategory>>((ref) async {
  return ref.read(courseServiceProvider).fetchAllSubcategories();
});
