// Stage
class Stage2Model {
  final String stageId;
  final String stageName;

  Stage2Model({
    required this.stageId,
    required this.stageName,
  });

  factory Stage2Model.fromMap(Map<String, dynamic> map) {
    return Stage2Model(
      stageId: map['stage_id'],
      stageName: map['stage_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stage_id': stageId,
      'stage_name': stageName,
    };
  }
}

// Board
class BoardModel {
  final String boardId;
  final String boardName;
  final String stageId;
  final String? stageName;

  BoardModel({
    required this.boardId,
    required this.boardName,
    required this.stageId,
    this.stageName,
  });

  factory BoardModel.fromMap(Map<String, dynamic> map) {
    return BoardModel(
      boardId: map['board_id'],
      boardName: map['board_name'],
      stageId: map['stage_id'] ?? map['stages2']?['stage_id'] ?? '',
      stageName: map['stages2']?['stage_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'board_id': boardId,
      'board_name': boardName,
      'stage_id': stageId,
    };
  }
}

class StreamModel {
  final String streamId;
  final String streamName;
  final String boardId;
  final String? boardName;
  final StreamDetailModel? details;

  StreamModel({
    required this.streamId,
    required this.streamName,
    required this.boardId,
    this.boardName,
    this.details,
  });

  factory StreamModel.fromMap(Map<String, dynamic> map) {
    return StreamModel(
      streamId: map['stream_id'] as String,
      streamName: map['stream_name'] as String,
      boardId: (map['board_id'] ?? map['boards']?['board_id'] ?? '') as String,
      boardName: map['boards']?['board_name'] as String?,
      details: map['stream_details'] != null
          ? StreamDetailModel.fromMap(map['stream_details'] as Map<String, dynamic>)
          : null,
    );
  }

  factory StreamModel.fromJson(Map<String, dynamic> json) => StreamModel.fromMap(json);

  Map<String, dynamic> toMap() {
    return {
      'stream_id': streamId,
      'stream_name': streamName,
      'board_id': boardId,
    };
  }
}


// Core Subject
class CoreSubjectModel {
  final String coreId;
  final String subjectName;
  final String streamId;
  final String? streamName;

  CoreSubjectModel({
    required this.coreId,
    required this.subjectName,
    required this.streamId,
    this.streamName,
  });

  factory CoreSubjectModel.fromMap(Map<String, dynamic> map) {
    return CoreSubjectModel(
      coreId: map['core_id'],
      subjectName: map['subject_name'],
      streamId: map['stream_id'] ?? map['streams']?['stream_id'] ?? '',
      streamName: map['streams']?['stream_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'core_id': coreId,
      'subject_name': subjectName,
      'stream_id': streamId,
    };
  }
}

// Elective
class ElectiveModel {
  final String electiveId;
  final String subjectName;
  final String streamId;
  final String? streamName;

  ElectiveModel({
    required this.electiveId,
    required this.subjectName,
    required this.streamId,
    this.streamName,
  });

  factory ElectiveModel.fromMap(Map<String, dynamic> map) {
    return ElectiveModel(
      electiveId: map['elective_id'],
      subjectName: map['subject_name'],
      streamId: map['stream_id'] ?? map['streams']?['stream_id'] ?? '',
      streamName: map['streams']?['stream_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'elective_id': electiveId,
      'subject_name': subjectName,
      'stream_id': streamId,
    };
  }
}

// Stream Details
class StreamDetailModel {
  final String detailId;
  final String streamId;
  final String? description;
  final String? duration;
  final double? fees;
  final String? note1;
  final String? note2;
  final String? note3;
  final String? curriculum;
  final String? imageUrl;
  final DateTime? createdAt;

  StreamDetailModel({
    required this.detailId,
    required this.streamId,
    this.description,
    this.duration,
    this.fees,
    this.note1,
    this.note2,
    this.note3,
    this.curriculum,
    this.imageUrl,
    this.createdAt,
  });

  factory StreamDetailModel.fromMap(Map<String, dynamic> map) {
    return StreamDetailModel(
      detailId: map['detail_id'],
      streamId: map['stream_id'],
      description: map['description'],
      duration: map['duration'],
      fees: map['fees'] != null ? double.tryParse(map['fees'].toString()) : null,
      note1: map['note1'],
      note2: map['note2'],
      note3: map['note3'],
      curriculum: map['curriculum'],
      imageUrl: map['image_url'],
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'detail_id': detailId,
      'stream_id': streamId,
      'description': description,
      'duration': duration,
      'fees': fees,
      'note1': note1,
      'note2': note2,
      'note3': note3,
      'curriculum': curriculum,
      'image_url': imageUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
