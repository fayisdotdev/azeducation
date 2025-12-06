import 'package:azeducation/features/auth/admin/add_admin.dart';
import 'package:azeducation/features/auth/login_page.dart';
import 'package:azeducation/features/auth/student/student_signup.dart';
import 'package:azeducation/features/auth/teacher/teacher_signup.dart';
import 'package:azeducation/features/home/students_homepage.dart';
import 'package:azeducation/features/universities_tier/admin/admin_featured_universities.dart';
import 'package:azeducation/features/universities_tier/show/show_mixed.dart';
import 'package:azeducation/features/universities_tier/show/university_by_category.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:azeducation/features/universities_tier/university_session.dart';
import 'package:azeducation/features/universities_tier/videos/show.dart';
import 'package:azeducation/models/user_model.dart';
import 'package:azeducation/providers/auth_provider.dart';
import 'package:azeducation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider);
    final userProfileAsync = ref.watch(currentUserProfileProvider);
    final data = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: userProfileAsync.when(
          data: (user) {
            if (user == null) return const Text("No user data found.");

            Student? student = user.isStudent ? user as Student : null;
            Teacher? teacher = user.isTeacher ? user as Teacher : null;

            return data.isLoading
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Logged in as: ${user.email}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Role: ${user.isAdmin ? "Admin" : user.isTeacher ? "Teacher" : "Student"}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ---- STUDENT DETAILS ----
                        if (student != null) ...[
                          const Text(
                            "Student Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Fetch student's courses dynamically
                          FutureBuilder<List<Course>>(
                            future: data.fetchStudentCourses(student.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text("University: Not Assigned", style: TextStyle(fontSize: 15)),
                                    Text("Course: Not Assigned", style: TextStyle(fontSize: 15)),
                                    SizedBox(height: 4),
                                    Text(
                                      "Enrolled Subjects: No subjects enrolled",
                                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                );
                              }

                              final studentCourses = snapshot.data!;
                              final course = studentCourses.first; // assuming one active course
                              final universityName = course.university?.universityName ?? "Not Assigned";
                              final courseName = course.courseName;
                              final enrolledSubjects = course.subjects.map((s) => s.subjectName).toList();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("University: $universityName", style: const TextStyle(fontSize: 15)),
                                  Text("Course: $courseName", style: const TextStyle(fontSize: 15)),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Enrolled Subjects:",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (enrolledSubjects.isNotEmpty)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: enrolledSubjects
                                          .map((s) => Text("• $s", style: const TextStyle(fontSize: 14)))
                                          .toList(),
                                    )
                                  else
                                    const Text(
                                      "No subjects enrolled",
                                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                                    ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                        ],

                        // ---- TEACHER DETAILS ----
                        if (teacher != null) ...[
                          const Text(
                            "Subjects Assigned:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(teacher.subjects.join(', ')),
                        ],

                        const SizedBox(height: 16),

                        // ---------- ROUTE BUTTONS ----------
                        if (user.isAdmin || user.isTeacher)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const UniversitySession()),
                              );
                            },
                            child: const Text("Admin University Session"),
                          ),
                        const SizedBox(height: 12),
                        if (user.isTeacher || user.isStudent)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const UniversityCourseSubjectListPage()),
                              );
                            },
                            child: const Text("Universities and Courses"),
                          ),

                           if (user.isStudent)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const StudentHomePage()),
                              );
                            },
                            child: const Text("Students Homepage"),
                          ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          child: const Text('View By Category'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const UniversitiesByCategoryPage()),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const VideoStreamPage()),
                            );
                          },
                          child: const Text("Recorded Classes"),
                        ),
                        const SizedBox(height: 12),
                        if (user.isTeacher)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const StudentSignupPage()),
                              );
                            },
                            child: const Text("Student Signup"),
                          ),
                        const SizedBox(height: 12),
                        if (user.isAdmin)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AddTeacherPage()),
                              );
                            },
                            child: const Text("Add Teacher"),
                          ),
                        const SizedBox(height: 12),
                        if (user.isAdmin)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AddAdminPage()),
                              );
                            },
                            child: const Text("Add Admin"),
                          ),
                        const SizedBox(height: 12),
                        if (user.isAdmin)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AdminFeaturedUniversitiesPage()),
                              );
                            },
                            child: const Text("Admin Features"),
                          ),
                      ],
                    ),
                  );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, _) => Text("Error loading user: $err"),
        ),
      ),
    );
  }
}
