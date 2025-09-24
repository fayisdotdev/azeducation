import 'package:azeducation/features/auth/admin/add_admin.dart';
import 'package:azeducation/features/auth/login_page.dart';
import 'package:azeducation/features/auth/student/student_signup.dart';
import 'package:azeducation/features/auth/teacher/teacher_signup.dart';
import 'package:azeducation/features/courses/add_courses.dart';
import 'package:azeducation/features/courses/list_courses.dart';
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
            if (user == null) {
              return const Text("No user data found.");
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  "Role: ${user.isAdmin
                      ? "Admin"
                      : user.isTeacher
                      ? "Teacher"
                      : "Student"}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 24),
                if (user.isAdmin || user.isTeacher)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddCoursePage(),
                        ),
                      );
                    },
                    child: const Text("Add Course"),
                  ),
                const SizedBox(height: 12),
                if (user.isStudent || user.isTeacher || user.isAdmin)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CourseListPage(),
                        ),
                      );
                    },
                    child: const Text("Show Courses"),
                  ),
                const SizedBox(height: 12),
                if (user.isTeacher)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StudentSignupPage(),
                        ),
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
                        MaterialPageRoute(
                          builder: (_) => const AddTeacherPage(),
                        ),
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
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, _) => Text("Error loading user: $err"),
        ),
      ),
    );
  }
}
