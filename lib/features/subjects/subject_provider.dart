import 'package:azeducation/features/subjects/subject_model.dart';
import 'package:azeducation/features/subjects/subject_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subjectServiceProvider =
    Provider<SubjectService>((ref) => SubjectService());

/// All subjects (grid)
final allSubjectsProvider = FutureProvider<List<SubjectModel>>((ref) async {
  return ref.read(subjectServiceProvider).fetchSubjects();
});

/// All stages
final stageListProvider = FutureProvider<List<Stage>>((ref) async {
  return ref.read(subjectServiceProvider).fetchStages();
});

/// Classes by stage
final classListProvider =
    FutureProvider.family<List<ClassItem>, String>((ref, stageId) async {
  return ref.read(subjectServiceProvider).fetchClasses(stageId);
});

/// All classes (flat)
final allClassesProvider = FutureProvider<List<ClassItem>>((ref) async {
  return ref.read(subjectServiceProvider).fetchAllClasses();
});

/// Subjects by class
final subjectListByClassProvider =
    FutureProvider.family<List<SubjectModel>, String>((ref, classId) async {
  return ref.read(subjectServiceProvider).fetchSubjectsByClass(classId);
});
