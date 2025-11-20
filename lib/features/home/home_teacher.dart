import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/auth/teacher/teacher_signup.dart';
import 'package:azeducation/features/universities_tier/show/university_by_category.dart';
import 'package:azeducation/features/universities_tier/videos/show.dart';
import 'package:azeducation/providers/auth_provider.dart';

class HomeTeacherPage extends ConsumerWidget {
  const HomeTeacherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Teacher Home")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Teacher Menu',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            _SidebarTile(
              icon: Icons.category,
              label: "View By Category",
              onTap: () => _open(context, const UniversitiesByCategoryPage()),
            ),
            _SidebarTile(
              icon: Icons.video_library,
              label: "Recorded Classes",
              onTap: () => _open(context, const VideoStreamPage()),
            ),
            _SidebarTile(
              icon: Icons.person_add_alt_1,
              label: "Add Student",
              onTap: () => _open(context, const AddTeacherPage()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await auth.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Welcome, Teacher! Use the sidebar to navigate.'),
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.pop(context); // close drawer
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _SidebarTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(label), onTap: onTap);
  }
}
