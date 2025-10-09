import 'package:azeducation/features/auth/login_page.dart';
import 'package:azeducation/features/new_db/board/boards_page.dart';
import 'package:azeducation/features/new_db/stage/stages_page.dart';
import 'package:azeducation/features/new_db/stream/streams_page.dart';
import 'package:azeducation/features/new_db/subjects/subjects_page_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class EducationSummaryTabs extends ConsumerStatefulWidget {
  const EducationSummaryTabs({super.key});

  @override
  ConsumerState<EducationSummaryTabs> createState() => _EducationSummaryTabsState();
}

class _EducationSummaryTabsState extends ConsumerState<EducationSummaryTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text("Education Summary"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Stages"),
            Tab(text: "Boards"),
            Tab(text: "Streams"),
            Tab(text: "Subjects"),
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
          // Stage tab
          StagesPage(),

          // Boards tab: handles stage selection internally
          BoardsPageTab(),

          // Streams tab: handles board selection internally
          StreamsPageTab(),

          // Subjects tab: handles stream selection internally
          SubjectsPageTab(),
        ],
      ),
    );
  }
}
