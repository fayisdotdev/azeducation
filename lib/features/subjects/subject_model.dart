class SubjectModel {
  final String id;
  final String name;
  final String stageId;
  final String? stageName;
  final String? classId;
  final String? className;
  final String? duration;
  final double? fees;
  final String? note1;
  final String? note2;
  final String? note3;
  final String? curriculum;
  final String? imageUrl;

  SubjectModel({
    required this.id,
    required this.name,
    required this.stageId,
    this.stageName,
    this.classId,
    this.className,
    this.duration,
    this.fees,
    this.note1,
    this.note2,
    this.note3,
    this.curriculum,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'stage_id': stageId,
      'class_id': classId,
      'duration': duration,
      'fees': fees,
      'note1': note1,
      'note2': note2,
      'note3': note3,
      'curriculum': curriculum,
      'image_url': imageUrl,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'],
      name: map['name'],
      stageId: map['stage_id'] ?? map['stages']?['stage_id'] ?? '',
      stageName: map['stages']?['stage_name'] ?? '',
      classId: map['class_id'] ?? map['classes']?['class_id'],
      className: map['classes']?['class_name'],
      duration: map['duration'],
      fees: map['fees'] != null ? double.tryParse(map['fees'].toString()) : null,
      note1: map['note1'],
      note2: map['note2'],
      note3: map['note3'],
      curriculum: map['curriculum'],
      imageUrl: map['image_url'],
    );
  }
}


//stage
class Stage {
  final String stageId;
  final String stageName;

  Stage({required this.stageId, required this.stageName});

  factory Stage.fromMap(Map<String, dynamic> map) {
    return Stage(
      stageId: map['stage_id'],
      stageName: map['stage_name'],
    );
  }
}


//classes
class ClassItem {
  final String classId;
  final String className;
  final String stageId;

  ClassItem({
    required this.classId,
    required this.className,
    required this.stageId,
  });

  factory ClassItem.fromMap(Map<String, dynamic> map) {
    return ClassItem(
      classId: map['class_id'],
      className: map['class_name'],
      stageId: map['stage_id'],
    );
  }
}

