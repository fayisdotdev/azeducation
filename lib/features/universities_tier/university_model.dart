// models.dart

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class University {
  final String universityId;
  final String universityName;
  final DateTime createdAt;

  University({
    required this.universityId,
    required this.universityName,
    required this.createdAt,
  });

  factory University.fromJson(Map<String, dynamic> json) => University(
    universityId: json['university_id'],
    universityName: json['university_name'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'university_id': universityId,
    'university_name': universityName,
  };
}

class CourseCategory {
  final String categoryId;
  final String categoryName;
  final DateTime createdAt;

  CourseCategory({
    required this.categoryId,
    required this.categoryName,
    required this.createdAt,
  });

  factory CourseCategory.fromJson(Map<String, dynamic> json) => CourseCategory(
    categoryId: json['category_id'],
    categoryName: json['category_name'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'category_id': categoryId,
    'category_name': categoryName,
  };
}

class Course {
  final String courseId;
  final String universityId;
  final String courseName;
  final String? categoryId;
  final DateTime createdAt;

  Course({
    required this.courseId,
    required this.universityId,
    required this.courseName,
    this.categoryId,
    required this.createdAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    courseId: json['course_id'],
    universityId: json['university_id'],
    courseName: json['course_name'],
    categoryId: json['category_id'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'course_id': courseId,
    'university_id': universityId,
    'course_name': courseName,
    'category_id': categoryId,
  };
}

class Subject {
  final String subjectId;
  final String courseId;
  final String universityId;
  final String subjectName;
  final DateTime createdAt;

  Subject({
    required this.subjectId,
    required this.courseId,
    required this.universityId,
    required this.subjectName,
    required this.createdAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    subjectId: json['subject_id'],
    courseId: json['course_id'],
    universityId: json['university_id'],
    subjectName: json['subject_name'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'subject_id': subjectId,
    'course_id': courseId,
    'university_id': universityId,
    'subject_name': subjectName,
  };
}

class CourseDetail {
  final String detailId;
  final String? subjectId;
  final String courseId;
  final String universityId;
  final String? description;
  final String? duration;
  final num? fees;
  final String? note1;
  final String? note2;
  final String? note3;
  final String? syllabus;
  final String? imageUrl;
  final DateTime createdAt;

  CourseDetail({
    required this.detailId,
    this.subjectId,
    required this.courseId,
    required this.universityId,
    this.description,
    this.duration,
    this.fees,
    this.note1,
    this.note2,
    this.note3,
    this.syllabus,
    this.imageUrl,
    required this.createdAt,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) => CourseDetail(
    detailId: json['detail_id'],
    subjectId: json['subject_id'],
    courseId: json['course_id'],
    universityId: json['university_id'],
    description: json['description'],
    duration: json['duration'],
    fees: json['fees'],
    note1: json['note1'],
    note2: json['note2'],
    note3: json['note3'],
    syllabus: json['syllabus'],
    imageUrl: json['image_url'],
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'detail_id': detailId,
    'subject_id': subjectId,
    'course_id': courseId,
    'university_id': universityId,
    'description': description,
    'duration': duration,
    'fees': fees,
    'note1': note1,
    'note2': note2,
    'note3': note3,
    'syllabus': syllabus,
    'image_url': imageUrl,
  };
}
