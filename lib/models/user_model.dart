// lib/models/user_model.dart

import 'package:flutter/foundation.dart';

/// Base user model
class UserModel {
  final String id;
  final String name;
  final String email;
  final String password; // plain text as requested
  final String mobile;
  final bool isAdmin;
  final bool isTeacher;
  final bool isStudent;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.mobile,
    this.isAdmin = false,
    this.isTeacher = false,
    this.isStudent = false,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      mobile: map['mobile'] as String,
      isAdmin: map['is_admin'] as bool? ?? false,
      isTeacher: map['is_teacher'] as bool? ?? false,
      isStudent: map['is_student'] as bool? ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'mobile': mobile,
      'is_admin': isAdmin,
      'is_teacher': isTeacher,
      'is_student': isStudent,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// Teacher model extending UserModel
class Teacher extends UserModel {
  final List<String> subjects;

  Teacher({
    required String id,
    required String name,
    required String email,
    required String password,
    required String mobile,
    this.subjects = const [],
    DateTime? createdAt,
  }) : super(
          id: id,
          name: name,
          email: email,
          password: password,
          mobile: mobile,
          isTeacher: true,
          createdAt: createdAt,
        );

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      mobile: map['mobile'] as String,
      subjects: (map['subjects'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final m = super.toMap();
    m['subjects'] = subjects;
    return m;
  }
}

/// Student model extending UserModel
class Student extends UserModel {
  final List<String> courses;

  Student({
    required String id,
    required String name,
    required String email,
    required String password,
    required String mobile,
    this.courses = const [],
    DateTime? createdAt,
  }) : super(
          id: id,
          name: name,
          email: email,
          password: password,
          mobile: mobile,
          isStudent: true,
          createdAt: createdAt,
        );

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      mobile: map['mobile'] as String,
      courses: (map['courses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final m = super.toMap();
    m['courses'] = courses;
    return m;
  }
}

/// Admin model extending UserModel
class Admin extends UserModel {
  Admin({
    required String id,
    required String name,
    required String email,
    required String password,
    required String mobile,
    DateTime? createdAt,
  }) : super(
          id: id,
          name: name,
          email: email,
          password: password,
          mobile: mobile,
          isAdmin: true,
          createdAt: createdAt,
        );

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      mobile: map['mobile'] as String,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }
}
