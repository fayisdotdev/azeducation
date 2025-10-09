import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/new_db/new_model.dart';
import 'package:azeducation/features/new_db/new_provider.dart';
import 'package:uuid/uuid.dart';

class AddStreamDetailsPage extends ConsumerStatefulWidget {
  final String? streamId;
  final String? streamName;

  const AddStreamDetailsPage({super.key, this.streamId, this.streamName});

  @override
  ConsumerState<AddStreamDetailsPage> createState() =>
      _AddStreamDetailsPageState();
}

class _AddStreamDetailsPageState extends ConsumerState<AddStreamDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _feesCtrl = TextEditingController();
  final _note1Ctrl = TextEditingController();
  final _note2Ctrl = TextEditingController();
  final _note3Ctrl = TextEditingController();
  final _curriculumCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();

  String? _selectedStreamId;

  @override
  void initState() {
    super.initState();
    _selectedStreamId = widget.streamId;
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _durationCtrl.dispose();
    _feesCtrl.dispose();
    _note1Ctrl.dispose();
    _note2Ctrl.dispose();
    _note3Ctrl.dispose();
    _curriculumCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveDetails() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStreamId == null || _selectedStreamId!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a stream')));
      return;
    }

    final detail = StreamDetailModel(
      detailId: const Uuid().v4(),
      streamId: _selectedStreamId!,
      description: _descCtrl.text.trim(),
      duration: _durationCtrl.text.trim(),
      fees: double.tryParse(_feesCtrl.text.trim()),
      note1: _note1Ctrl.text.trim(),
      note2: _note2Ctrl.text.trim(),
      note3: _note3Ctrl.text.trim(),
      curriculum: _curriculumCtrl.text.trim(),
      imageUrl: _imageUrlCtrl.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(educationServiceProvider).addStreamDetails(detail);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Stream details added successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final allStreams = ref.watch(allStreamsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Stream Details')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (widget.streamId == null) ...[
              const Text('Select Stream'),
              const SizedBox(height: 8),
              allStreams.when(
                data: (streams) => DropdownButtonFormField<String>(
                  value: _selectedStreamId,
                  hint: const Text('Choose Stream'),
                  items: streams.map((s) {
                    // Build a readable label: "Stage → Board → Stream"
                    final streamLabel = s.boardName != null
                        ? "${s.boardName} → ${s.streamName}"
                        : s.streamName;

                    return DropdownMenuItem(
                      value: s.streamId,
                      child: Text(streamLabel),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedStreamId = v),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Please select a stream' : null,
                ),

                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            TextFormField(
              controller: _durationCtrl,
              decoration: const InputDecoration(labelText: 'Duration'),
            ),
            TextFormField(
              controller: _feesCtrl,
              decoration: const InputDecoration(labelText: 'Fees'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _note1Ctrl,
              decoration: const InputDecoration(labelText: 'Note 1'),
            ),
            TextFormField(
              controller: _note2Ctrl,
              decoration: const InputDecoration(labelText: 'Note 2'),
            ),
            TextFormField(
              controller: _note3Ctrl,
              decoration: const InputDecoration(labelText: 'Note 3'),
            ),
            TextFormField(
              controller: _curriculumCtrl,
              decoration: const InputDecoration(labelText: 'Curriculum'),
            ),
            TextFormField(
              controller: _imageUrlCtrl,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveDetails,
              icon: const Icon(Icons.save),
              label: const Text('Save Details'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
