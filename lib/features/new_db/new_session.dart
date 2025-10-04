import 'package:azeducation/features/new_db/allsubjcets.dart';
import 'package:azeducation/features/new_db/board/add_board.dart';
import 'package:azeducation/features/new_db/show_new.dart';
import 'package:azeducation/features/new_db/subjects/add_core.dart';
import 'package:azeducation/features/new_db/stage2/add_stage2.dart';
import 'package:azeducation/features/new_db/stream/add_stream.dart';
import 'package:azeducation/features/new_db/subjects/add_elective_subject.dart';
import 'package:flutter/material.dart';

class NewSession extends StatelessWidget {
  const NewSession({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subject Session")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddStage2Page()),
                  );
                },
                child: const Text("Add Stage2"),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddBoardPage()),
                  );
                },
                child: const Text("Add Boards"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddStreamPage()),
                  );
                },
                child: const Text("Add Streams"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddCoreSubjectPage(),
                    ),
                  );
                },
                child: const Text("Add subjects"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddElectivePage()),
                  );
                },
                child: const Text("Add Elective subjects"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EducationSummaryPage(),
                    ),
                  );
                },
                child: const Text("Show everything"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EducationSummaryTabs(),
                    ),
                  );
                },
                child: const Text("Show everything tabs"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
