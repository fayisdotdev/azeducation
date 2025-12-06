import 'package:azeducation/features/universities_tier/university_services.dart';
import 'package:azeducation/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Fetches a Student with their enrolled courses (with full relations)
Future<Student?> fetchStudentWithCourses(String studentId) async {
  final supabase = Supabase.instance.client;
  // 1. Fetch student user row
  final userRes = await supabase
      .from('users')
      .select()
      .eq('id', studentId)
      .maybeSingle();
  if (userRes == null) return null;
  final student = Student.fromMap(userRes);

  // 2. Fetch enrolled courses (with relations)
  final db = DatabaseService();
  final enrolledCourses = await db.getStudentCourses(studentId);

  // 3. Attach to student model
  return Student(
    id: student.id,
    name: student.name,
    email: student.email,
    password: student.password,
    mobile: student.mobile,
    universityId: student.universityId,
    universityName: student.universityName,
    courseId: student.courseId,
    courseName: student.courseName,
    enrolledSubjects: student.enrolledSubjects,
    createdAt: student.createdAt,
    enrolledCourses: enrolledCourses,
  );
}

/// Utility to fetch user details by role (expand as needed)
Future<UserModel?> fetchUserWithRoleDetails(String userId, String role) async {
  switch (role) {
    case 'student':
      return await fetchStudentWithCourses(userId);
    // case 'teacher':
    //   return await fetchTeacherWithSubjects(userId);
    // case 'admin':
    //   return await fetchAdminDetails(userId);
    default:
      return null;
  }
}
