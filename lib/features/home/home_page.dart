import 'package:azeducation/features/auth/admin/add_admin.dart';
import 'package:azeducation/features/auth/login_page.dart';
import 'package:azeducation/features/auth/student/student_signup.dart';
import 'package:azeducation/features/auth/teacher/teacher_signup.dart';
import 'package:azeducation/features/universities_tier/admin/admin_featured_universities.dart';
import 'package:azeducation/features/universities_tier/show/show_mixed.dart';
import 'package:azeducation/features/universities_tier/show/university_by_category.dart';
import 'package:azeducation/features/universities_tier/university_session.dart';
import 'package:azeducation/features/universities_tier/videos/show.dart';
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
            tooltip: 'Logout',
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
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: userProfileAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text("No user data found."));
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            children: [
              // User info card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          user.email.isNotEmpty
                              ? user.email[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.email,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Role: ${user.isAdmin
                                  ? "Admin"
                                  : user.isTeacher
                                  ? "Teacher"
                                  : "Student"}",
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                    .withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Animated action buttons
              ...[
                if (user.isAdmin || user.isTeacher)
                  _HomeActionButton(
                    icon: Icons.admin_panel_settings,
                    label: "Admin University Session",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UniversitySession(),
                        ),
                      );
                    },
                  ),
                if (user.isTeacher || user.isStudent)
                  _HomeActionButton(
                    icon: Icons.school,
                    label: "Universities and Courses",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const UniversityCourseSubjectListPage(),
                        ),
                      );
                    },
                  ),
                if (user.isAdmin || user.isTeacher || user.isStudent)
                  _HomeActionButton(
                    icon: Icons.category,
                    label: "View By Category",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UniversitiesByCategoryPage(),
                        ),
                      );
                    },
                  ),
                if (user.isAdmin || user.isTeacher || user.isStudent)
                  _HomeActionButton(
                    icon: Icons.video_library,
                    label: "Recorded Classes",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VideoStreamPage(),
                        ),
                      );
                    },
                  ),
                if (user.isTeacher)
                  _HomeActionButton(
                    icon: Icons.person_add_alt_1,
                    label: "Student Signup",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StudentSignupPage(),
                        ),
                      );
                    },
                  ),
                if (user.isAdmin)
                  _HomeActionButton(
                    icon: Icons.person_add,
                    label: "Add Teacher",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddTeacherPage(),
                        ),
                      );
                    },
                  ),
                if (user.isAdmin)
                  _HomeActionButton(
                    icon: Icons.admin_panel_settings_outlined,
                    label: "Add Admin",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddAdminPage()),
                      );
                    },
                  ),
                // Uncomment if you want admin features button
                if (user.isAdmin)
                  _HomeActionButton(
                    icon: Icons.star,
                    label: "Admin Features",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminFeaturedUniversitiesPage()),
                      );
                    },
                  ),
              ].expand((w) => [w, const SizedBox(height: 16)]).toList(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error loading user: $err")),
      ),
    );
  }
}

class _HomeActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _HomeActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
