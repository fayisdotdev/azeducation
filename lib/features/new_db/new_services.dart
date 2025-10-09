// ignore_for_file: avoid_print

import 'package:azeducation/features/new_db/new_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EducationService {
  final SupabaseClient supabase = Supabase.instance.client;

  // ---------- Stages ----------
  Future<void> addStage(String name) async {
    await supabase.from('stages').insert({'stage_name': name});
  }

  Future<List<Stage2Model>> fetchStages() async {
    print("⏳ Fetching stages...");
    final response = await supabase.from('stages').select();
    return (response as List)
        .map((s) => Stage2Model.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  // ---------- Boards ----------
  Future<void> addBoard(String name, String stageId) async {
    await supabase.from('boards').insert({
      'board_name': name,
      'stage_id': stageId,
    });
  }

  Future<List<BoardModel>> fetchBoards(String stageId) async {
    print("⏳ Fetching boards for stage $stageId...");
    final response = await supabase
        .from('boards')
        .select('*, stages(*)')
        .eq('stage_id', stageId);
    return (response as List)
        .map((b) => BoardModel.fromMap(b as Map<String, dynamic>))
        .toList();
  }

  // ---------- Streams ----------
  Future<void> addStream(String name, String boardId) async {
    await supabase.from('streams').insert({
      'stream_name': name,
      'board_id': boardId,
    });
  }

  Future<List<StreamModel>> fetchStreams(String boardId) async {
    print("⏳ Fetching streams for board $boardId...");
    final response = await supabase
        .from('streams')
        .select()
        .eq('board_id', boardId);
    final data = response as List<dynamic>;
    return data
        .map((json) => StreamModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<StreamModel>> fetchAllStreams() async {
    print("⏳ Fetching all streams...");
    final response = await supabase.from('streams').select('*, boards(*)');
    return (response as List)
        .map((s) => StreamModel.fromJson(s as Map<String, dynamic>))
        .toList();
  }

  // ---------- Subjects ----------
  Future<void> addSubject({
    required String name,
    String? duration,
    num? fees,
    String? note1,
    String? note2,
    String? note3,
    String? curriculum,
    String? imageUrl,
    String? stageId,
    String? classId,
  }) async {
    await supabase.from('subjects').insert({
      'name': name,
      'duration': duration,
      'fees': fees,
      'note1': note1,
      'note2': note2,
      'note3': note3,
      'curriculum': curriculum,
      'image_url': imageUrl,
      'stage_id': stageId,
      'class_id': classId,
    });
  }

  Future<List<SubjectModel>> fetchSubjects(String streamId) async {
    print("⏳ Fetching subjects for stream $streamId...");

    final response = await supabase
        .from('subjects')
        .select()
        .eq('stream_id', streamId);

    print("📦 Raw subjects data: $response");

    return (response as List)
        .map((s) => SubjectModel.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  // ---------- Electives ----------
  Future<void> addElective(String name, String streamId) async {
    await supabase.from('electives').insert({
      'subject_name': name,
      'stream_id': streamId,
    });
  }

  Future<List<ElectiveModel>> fetchElectives(String streamId) async {
    print("⏳ Fetching electives for stream $streamId...");
    final response = await supabase
        .from('electives')
        .select('*, streams(*)')
        .eq('stream_id', streamId);
    return (response as List)
        .map((e) => ElectiveModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // ---------- Stream Details ----------
  Future<void> addStreamDetails(StreamDetailModel details) async {
    await supabase.from('stream_details').insert(details.toMap());
  }

  Future<StreamDetailModel?> fetchStreamDetails(String streamId) async {
    print("⏳ Fetching stream details for stream $streamId...");
    final response = await supabase
        .from('stream_details')
        .select()
        .eq('stream_id', streamId)
        .maybeSingle();
    if (response == null) return null;
    return StreamDetailModel.fromMap(response);
  }

  Future<List<CoreSubjectModel>> fetchCoreSubjects(String streamId) async {
    print("⏳ Fetching core subjects for stream $streamId...");
    if (streamId.isEmpty) return []; // safety check

    final response = await supabase
        .from('core_subjects')
        .select()
        .eq('stream_id', streamId);

    print("📦 Raw core subjects data: $response");

    return (response as List)
        .map((s) => CoreSubjectModel.fromMap(s as Map<String, dynamic>))
        .toList();
  }
}
