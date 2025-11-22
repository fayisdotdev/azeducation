// sealed class UserModel {
//   final String id;
//   final String name;
//   final String email;
//   final String mobile;
//   final String _role;
//   final String password;
//   final DateTime createdAt;

//   UserModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.mobile,
//     required String role,
//     required this.password,
//     required this.createdAt,
//   }) : _role = role;

//   String get role => _role;

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     switch (map['role']) {
//       case 'student':
//         return Student.fromMap(map);
//       case 'teacher':
//         return Teacher.fromMap(map);
//       case 'admin':
//         return Admin.fromMap(map);
//       default:
//         throw Exception("Invalid user role: ${map['role']}");
//     }
//   }
// }

// class Student extends UserModel {
//   final String? coreSubjectId;
//   final List<Course>? courses; // Add courses

//   Student({
//     required super.id,
//     required super.name,
//     required super.email,
//     required super.mobile,
//     required super.password,
//     required super.createdAt,
//     required this.coreSubjectId,
//     this.courses,
//   }) : super(role: 'student');

//   factory Student.fromMap(Map<String, dynamic> map) {
//     return Student(
//       id: map['id'],
//       name: map['name'],
//       email: map['email'],
//       mobile: map['mobile'],
//       password: map['password'],
//       createdAt: DateTime.parse(map['created_at']),
//       coreSubjectId: map['core_subject_id'],
//       courses: (map['courses'] as List<dynamic>?)
//           ?.map((c) => Course.fromMap(c))
//           .toList(),
//     );
//   }
// }

// class Teacher extends UserModel {
//   final List<String>? subjects; // optional subjects field

//   Teacher({
//     required super.id,
//     required super.name,
//     required super.email,
//     required super.mobile,
//     required super.password,
//     required super.createdAt,
//     this.subjects,
//   }) : super(role: 'teacher');

//   factory Teacher.fromMap(Map<String, dynamic> map) {
//     return Teacher(
//       id: map['id'],
//       name: map['name'],
//       email: map['email'],
//       mobile: map['mobile'],
//       password: map['password'],
//       createdAt: DateTime.parse(map['created_at']),
//       subjects: (map['subjects'] as List<dynamic>?)?.cast<String>(),
//     );
//   }
// }

// class Admin extends UserModel {
//   Admin({
//     required super.id,
//     required super.name,
//     required super.email,
//     required super.mobile,
//     required super.password,
//     required super.createdAt,
//   }) : super(role: 'admin');

//   factory Admin.fromMap(Map<String, dynamic> map) {
//     return Admin(
//       id: map['id'],
//       name: map['name'],
//       email: map['email'],
//       mobile: map['mobile'],
//       password: map['password'],
//       createdAt: DateTime.parse(map['created_at']),
//     );
//   }
// }

// // Course model
// class Course {
//   final String id;
//   final String name;
//   final String description;
//   final String universityId;
//   final int durationMonths;

//   Course({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.universityId,
//     required this.durationMonths,
//   });

//   factory Course.fromMap(Map<String, dynamic> map) {
//     return Course(
//       id: map['id'],
//       name: map['name'],
//       description: map['description'],
//       universityId: map['university_id'],
//       durationMonths: map['duration'] as int,
//     );
//   }
// }

// // University model
// class University {
//   final String id;
//   final String name;
//   final String country;
//   final String imageUrl;
//   final int ranking;

//   University({
//     required this.id,
//     required this.name,
//     required this.country,
//     required this.imageUrl,
//     required this.ranking,
//   });

//   factory University.fromMap(Map<String, dynamic> map) {
//     return University(
//       id: map['id'],
//       name: map['name'],
//       country: map['country'],
//       imageUrl: map['image'],
//       ranking: map['ranking'] as int,
//     );
//   }
// }
