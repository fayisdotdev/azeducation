// ignore_for_file: avoid_print

import 'package:azeducation/features/new_db/new_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EducationService {
  final SupabaseClient supabase = Supabase.instance.client;

  // ---------- Stages ----------
  Future<void> addStage(String name) async {
    await supabase.from('stages2').insert({'stage_name': name});
  }

  Future<List<Stage2Model>> fetchStages() async {
    print("⏳ Fetching stages...");
    final response = await supabase.from('stages2').select();
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
    final response =
        await supabase.from('boards').select('*, stages2(*)').eq('stage_id', stageId);
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
  final response = await supabase
      .from('streams')
      .select()
      .eq('board_id', boardId);

  final data = response as List<dynamic>; // <-- important
  return data.map((json) => StreamModel.fromJson(json as Map<String, dynamic>)).toList();
}


  // ---------- Core Subjects ----------
  Future<void> addCoreSubject(String name, String streamId) async {
    await supabase.from('core_subjects').insert({
      'subject_name': name,
      'stream_id': streamId,
    });
  }

  Future<List<CoreSubjectModel>> fetchCoreSubjects(String streamId) async {
    print("⏳ Fetching core subjects for stream $streamId...");
    final response = await supabase
        .from('core_subjects')
        .select('*, streams(*)')
        .eq('stream_id', streamId);
    return (response as List)
        .map((c) => CoreSubjectModel.fromMap(c as Map<String, dynamic>))
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
}
