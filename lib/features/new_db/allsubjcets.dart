import 'package:azeducation/features/new_db/board/boards_page.dart';
import 'package:azeducation/features/new_db/stage2/stages_page.dart';
import 'package:azeducation/features/new_db/stream/streams_page.dart';
import 'package:azeducation/features/new_db/subjects/subjects_page.dart';
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
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          StagesPage(),
          BoardsPage(stageId: '', stageName: '',),   // Shows all boards with a stage dropdown
          StreamsPage(boardId: '', boardName: '',),  // Shows all streams with a board dropdown
          SubjectsPage(streamId: '', streamName: '',), // Shows subjects for selected stream
        ],
      ),
    );
  }
}
