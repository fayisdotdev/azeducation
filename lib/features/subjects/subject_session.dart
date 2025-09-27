import 'package:azeducation/features/subjects/add_subject.dart';
import 'package:azeducation/features/subjects/classes/add_class.dart';
import 'package:azeducation/features/subjects/show_subjects/list_subject_page.dart';
import 'package:azeducation/features/subjects/stage/add_stage.dart';
import 'package:flutter/material.dart';

class SubjectSession extends StatelessWidget {
  const SubjectSession({super.key});

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
                    MaterialPageRoute(builder: (_) => const AddSubjectPage()),
                  );
                },
                child: const Text("Add subjects"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddStagePage()),
                  );
                },
                child: const Text("Add Stage"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddClassPage()),
                  );
                },
                child: const Text("Add Classes"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SubjectsListPage()),
                  );
                },
                child: const Text("Show Subjects"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
