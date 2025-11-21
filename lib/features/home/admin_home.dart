import 'package:azeducation/features/auth/login_page.dart';
import 'package:azeducation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminHome extends ConsumerWidget {
  const AdminHome({super.key});

  @override
    Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider);
    
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Admin Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            // Add admin options here as ListTile widgets
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Featured Universities'),
            ),
            ListTile(leading: Icon(Icons.people), title: Text('Add Admin')),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('University Session'),
            ),
            // Add more options as needed
          ],
        ),
      ),
      appBar: AppBar(title: const Text('Admin Home'),        actions: [
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
        ],),
      body: const Center(child: Text('Welcome, Admin!')),
    );
  }
}
