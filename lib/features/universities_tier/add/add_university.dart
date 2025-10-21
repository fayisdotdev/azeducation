import 'package:azeducation/providers/university/university_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final dataProvider = ChangeNotifierProvider((ref) => DataProvider());

class AddUniversityPage extends ConsumerStatefulWidget {
  const AddUniversityPage({super.key});

  @override
  ConsumerState<AddUniversityPage> createState() => _AddUniversityPageState();
}

class _AddUniversityPageState extends ConsumerState<AddUniversityPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Add University")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "University Name"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  await ref.read(dataProvider).addUniversity(_controller.text);
                  Navigator.pop(context);
                }
              },
              child: provider.isLoading
                  ? CircularProgressIndicator()
                  : Text("Add University"),
            ),
          ],
        ),
      ),
    );
  }
}
