import 'package:azeducation/features/subjects/show_subjects/all_subjects.dart';
import 'package:azeducation/features/subjects/show_subjects/class_view.dart';
import 'package:azeducation/features/subjects/show_subjects/stage_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:azeducation/features/auth/login_page.dart';

class SubjectsListPage extends ConsumerStatefulWidget {
  const SubjectsListPage({super.key});

  @override
  ConsumerState<SubjectsListPage> createState() => _SubjectsListPageState();
}

class _SubjectsListPageState extends ConsumerState<SubjectsListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subjects Explorer"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "By Stage"),
            Tab(text: "By Class"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: "Login",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AllSubjectsPage(),
          SubjectsByStagePage(),
          SubjectsByClassPage(),
        ],
      ),
    );
  }
}
