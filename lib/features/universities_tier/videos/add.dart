import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadVideoPage extends StatefulWidget {
  const UploadVideoPage({super.key});

  @override
  State<UploadVideoPage> createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  bool isLoading = false;

  final supabase = Supabase.instance.client;

  Future<void> uploadVideo() async {
    final title = _titleController.text.trim();
    final url = _urlController.text.trim();

    if (title.isEmpty || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill both fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await supabase.from('course_videos').insert({
        'title': title,
        'video_url': url,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video uploaded successfully')),
      );

      _titleController.clear();
      _urlController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Video')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Video Title'),
            ),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'YouTube URL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : uploadVideo,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Upload Video'),
            ),
          ],
        ),
      ),
    );
  }
}
