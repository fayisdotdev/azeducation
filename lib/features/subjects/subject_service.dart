import 'dart:io';
import 'dart:typed_data';

import 'package:azeducation/features/subjects/subject_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubjectService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// ========== Subjects ==========
  Future<void> addSubject(SubjectModel subject) async {
    await supabase.from('subjects').insert(subject.toMap());
  }

  Future<List<SubjectModel>> fetchSubjects() async {
    print("⏳ Fetching all subjects...");
    try {
      final response = await supabase
          .from('subjects')
          .select('*, stages(*), classes(*)');

      final subjects = (response as List)
          .map((s) => SubjectModel.fromMap(s as Map<String, dynamic>))
          .toList();

      print("✅ Loaded ${subjects.length} subjects");
      return subjects;
    } catch (e, st) {
      print("❌ Error fetching subjects: $e\n$st");
      rethrow;
    }
  }

  /// ========== Stages ==========
  Future<void> addStage(String name) async {
    await supabase.from('stages').insert({'stage_name': name});
  }

  Future<List<Stage>> fetchStages() async {
    print("⏳ Fetching stages...");
    try {
      final response = await supabase.from('stages').select();
      final stages = (response as List)
          .map((s) => Stage.fromMap(s as Map<String, dynamic>))
          .toList();

      print("✅ Loaded ${stages.length} stages");
      return stages;
    } catch (e, st) {
      print("❌ Error fetching stages: $e\n$st");
      rethrow;
    }
  }

  /// ========== Classes ==========
  Future<void> addClass(String name, String stageId) async {
    await supabase.from('classes').insert({
      'class_name': name,
      'stage_id': stageId,
    });
  }

  Future<List<ClassItem>> fetchClasses(String stageId) async {
    print("⏳ Fetching classes for stage $stageId...");
    try {
      final response =
          await supabase.from('classes').select().eq('stage_id', stageId);

      final classes = (response as List)
          .map((c) => ClassItem.fromMap(c as Map<String, dynamic>))
          .toList();

      print("✅ Loaded ${classes.length} classes for stage $stageId");
      return classes;
    } catch (e, st) {
      print("❌ Error fetching classes for stage $stageId: $e\n$st");
      rethrow;
    }
  }

  Future<List<ClassItem>> fetchAllClasses() async {
    print("⏳ Fetching all classes...");
    try {
      final response = await supabase.from('classes').select();
      final classes = (response as List)
          .map((c) => ClassItem.fromMap(c as Map<String, dynamic>))
          .toList();

      print("✅ Loaded ${classes.length} classes");
      return classes;
    } catch (e, st) {
      print("❌ Error fetching all classes: $e\n$st");
      rethrow;
    }
  }

  /// ========== Subjects by Class ==========
  Future<List<SubjectModel>> fetchSubjectsByClass(String classId) async {
    print("⏳ Fetching subjects for class $classId...");
    try {
      final response = await supabase
          .from('subjects')
          .select('*, stages(*), classes(*)')
          .eq('class_id', classId);

      final subjects = (response as List)
          .map((s) => SubjectModel.fromMap(s as Map<String, dynamic>))
          .toList();

      print("✅ Loaded ${subjects.length} subjects for class $classId");
      return subjects;
    } catch (e, st) {
      print("❌ Error fetching subjects for class $classId: $e\n$st");
      rethrow;
    }
  }

  /// ========== Storage Upload ==========
  Future<String?> uploadSubjectImage({
    File? file,
    Uint8List? bytes,
    required String subjectId,
    bool isWeb = false,
  }) async {
    try {
      final filePath = '$subjectId.jpg';

      if (isWeb && bytes != null) {
        await supabase.storage.from('subjects').uploadBinary(filePath, bytes);
      } else if (file != null) {
        await supabase.storage
            .from('subjects')
            .upload(
              filePath,
              file,
              fileOptions: const FileOptions(upsert: true),
            );
      } else {
        return null;
      }

      final publicUrl =
          supabase.storage.from('subjects').getPublicUrl(filePath);
      print("✅ Uploaded subject image: $publicUrl");
      return publicUrl;
    } catch (e, st) {
      print("❌ Error uploading subject image: $e\n$st");
      return null;
    }
  }
}
