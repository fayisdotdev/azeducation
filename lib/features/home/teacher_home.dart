import 'package:flutter/material.dart';

class TeacherHome extends StatelessWidget {
  const TeacherHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Teacher Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            // Add teacher options here as ListTile widgets
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Featured Universities'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('University Session'),
            ),
            // Add more options as needed
          ],
        ),
      ),
      appBar: AppBar(title: const Text('Teacher Home')),
      body: const Center(child: Text('Welcome, Teacher!')),
    );
  }
}
