import 'package:azeducation/features/universities_tier/show/university_by_category.dart'
    show featuredUniversityIdsProvider;
import 'package:azeducation/features/universities_tier/university_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:azeducation/utils/error_utils.dart';

final dataProvider = ChangeNotifierProvider((ref) => DataProvider());

// Service to save featured university IDs to Supabase
Future<void> saveFeaturedUniversityIds(List<String> ids) async {
  final supabase = Supabase.instance.client;

  // DELETE all, but with a required WHERE condition
  await supabase
      .from('featured_universities')
      .delete()
      .neq('id', -1); // deletes all rows safely

  // Insert new values
  if (ids.isNotEmpty) {
    await supabase
        .from('featured_universities')
        .insert(ids.map((id) => {'university_id': id}).toList());
  }
}

class AdminFeaturedUniversitiesPage extends ConsumerStatefulWidget {
  const AdminFeaturedUniversitiesPage({super.key});

  @override
  ConsumerState<AdminFeaturedUniversitiesPage> createState() =>
      _AdminFeaturedUniversitiesPageState();
}

class _AdminFeaturedUniversitiesPageState
    extends ConsumerState<AdminFeaturedUniversitiesPage> {
  final Set<String> _featuredUniversityIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dataProvider).fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dataProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Featured Universities Setup')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select universities to feature at the top:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: provider.universities.map((u) {
                        return CheckboxListTile(
                          value: _featuredUniversityIds.contains(
                            u.universityId,
                          ),
                          title: Text(u.universityName),
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                _featuredUniversityIds.add(u.universityId);
                              } else {
                                _featuredUniversityIds.remove(u.universityId);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await saveFeaturedUniversityIds(
                          _featuredUniversityIds.toList(),
                        );
                        // Invalidate providers so changes are reflected immediately
                        ref.invalidate(dataProvider);
                        ref.invalidate(featuredUniversityIdsProvider);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Featured universities saved!'),
                          ),
                        );
                        Navigator.pop(context);
                      } catch (e, st) {
                        logError(e, st, 'Save Featured Button');
                        final msg = getFriendlyErrorMessage(e);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(msg)));
                      }
                    },
                    child: const Text('Save Featured'),
                  ),
                ],
              ),
            ),
    );
  }
}
