import 'package:azeducation/models/user_model.dart';
import 'package:azeducation/utils/user_role_fetch_utils.dart';
import 'package:azeducation/providers/user_provider.dart';
import 'package:azeducation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentHomePage extends ConsumerWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider);
    final userProfileAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: userProfileAsync.when(
        data: (user) {
          if (user == null)
            return const Center(child: Text("No user data found."));
          if (!user.isStudent)
            return const Center(child: Text("Access denied"));

          // Use FutureBuilder to fetch full student details with courses
          return FutureBuilder<Student?>(
            future: fetchStudentWithCourses(user.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final student = snapshot.data;
              if (student == null) {
                return const Center(child: Text("No student data found."));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ===== Welcome Card =====
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Welcome, ${student.name}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Email: ${student.email}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Role: Student",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ===== University & Course Card =====
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Academic Info",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(),
                            if (student.enrolledCourses != null &&
                                student.enrolledCourses!.isNotEmpty)
                              ...student.enrolledCourses!.map(
                                (course) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.school,
                                        color: Colors.orange,
                                      ),
                                      title: Text(
                                        course.university?.universityName ??
                                            "Not Assigned",
                                      ),
                                      subtitle: const Text("University"),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.book,
                                        color: Colors.green,
                                      ),
                                      title: Text(course.courseName),
                                      subtitle: const Text("Course"),
                                    ),
                                    if (course.subjects.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                          top: 4,
                                          bottom: 8,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Subjects:",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            ...course.subjects.map(
                                              (subj) => Text(
                                                "- ${subj.subjectName}",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                            if (student.enrolledCourses == null ||
                                student.enrolledCourses!.isEmpty)
                              const Text("No enrolled courses found."),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ===== Quick Actions =====
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.school),
                          label: const Text("Universities & Courses"),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/university_course_subject_list',
                            );
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.video_library),
                          label: const Text("Recorded Classes"),
                          onPressed: () {
                            Navigator.pushNamed(context, '/video_stream');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error loading user: $err")),
      ),
    );
  }
}
