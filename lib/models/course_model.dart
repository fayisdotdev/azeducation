class CourseModel {
  final String id;
  final String name;
  final String? duration;
  final double? fees;
  final String? note1;
  final String? note2;
  final String? note3;
  final String? curriculum;
  final String? imageUrl;

  CourseModel({
    required this.id,
    required this.name,
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
      'duration': duration,
      'fees': fees,
      'note1': note1,
      'note2': note2,
      'note3': note3,
      'curriculum': curriculum,
      'image_url': imageUrl,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
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
