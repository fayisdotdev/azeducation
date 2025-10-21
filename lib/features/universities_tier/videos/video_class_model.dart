// lib/models/video_class_model.dart
class VideoClassModel {
  final String id;
  final String title;
  final String videoUrl;
  final String universityId;
  final String universityName;
  final String courseId;
  final String courseName;
  final String subjectId;
  final String subjectName;
  final String? categoryId;
  String? categoryName; // NOT final
  final DateTime createdAt;

  VideoClassModel({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.universityId,
    required this.universityName,
    required this.courseId,
    required this.courseName,
    required this.subjectId,
    required this.subjectName,
    this.categoryId,
    this.categoryName,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'video_url': videoUrl,
      'university_id': universityId,
      'university_name': universityName,
      'course_id': courseId,
      'course_name': courseName,
      'subject_id': subjectId,
      'subject_name': subjectName,
      'category_id': categoryId,
      'category_name': categoryName,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory VideoClassModel.fromJson(Map<String, dynamic> json) {
    return VideoClassModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      videoUrl: json['video_url'] ?? '',
      universityId: json['university_id'] ?? '',
      universityName: json['university_name'] ?? '',
      courseId: json['course_id'] ?? '',
      courseName: json['course_name'] ?? '',
      subjectId: json['subject_id'] ?? '',
      subjectName: json['subject_name'] ?? '',
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
