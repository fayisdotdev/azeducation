import 'package:azeducation/features/new_db/new_model.dart';
import 'package:azeducation/features/new_db/new_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Main service provider
final educationServiceProvider =
    Provider<EducationService>((ref) => EducationService());

/// ---------- Stages ----------
final stageListProvider = FutureProvider<List<Stage2Model>>((ref) async {
  return ref.read(educationServiceProvider).fetchStages();
});

/// ---------- Boards ----------
final boardListProvider =
    FutureProvider.family<List<BoardModel>, String>((ref, stageId) async {
  return ref.read(educationServiceProvider).fetchBoards(stageId);
});

/// ---------- Streams ----------
final streamListProvider =
    FutureProvider.family<List<StreamModel>, String>((ref, boardId) async {
  return ref.read(educationServiceProvider).fetchStreams(boardId);
});

/// ---------- Core Subjects ----------
final coreSubjectsProvider =
    FutureProvider.family<List<CoreSubjectModel>, String>((ref, streamId) async {
  return ref.read(educationServiceProvider).fetchCoreSubjects(streamId);
});

/// ---------- Electives ----------
final electivesProvider =
    FutureProvider.family<List<ElectiveModel>, String>((ref, streamId) async {
  return ref.read(educationServiceProvider).fetchElectives(streamId);
});

/// ---------- Stream Details (with notes, fees, duration, etc.) ----------
final streamDetailsProvider =
    FutureProvider.family<StreamDetailModel?, String>((ref, streamId) async {
  return ref.read(educationServiceProvider).fetchStreamDetails(streamId);
});

/// ---------- Add entities (for mutation ops) ----------
final addBoardProvider =
    FutureProvider.family<void, ({String stageId, String boardName})>(
  (ref, params) async {
    await ref
        .read(educationServiceProvider)
        .addBoard(params.boardName, params.stageId);
    // refresh that stage’s boards
    ref.invalidate(boardListProvider(params.stageId));
  },
);

final addStreamProvider =
    FutureProvider.family<void, ({String boardId, String streamName})>(
  (ref, params) async {
    await ref
        .read(educationServiceProvider)
        .addStream(params.streamName, params.boardId);
    ref.invalidate(streamListProvider(params.boardId));
  },
);
