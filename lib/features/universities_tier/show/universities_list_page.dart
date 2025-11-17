import 'package:azeducation/features/universities_tier/show/show_mixed.dart';
import 'package:azeducation/features/universities_tier/show/widgets/university_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/features/universities_tier/university_model.dart';
import 'package:azeducation/features/universities_tier/add/add_courses.dart';
import 'package:azeducation/features/universities_tier/show/university_by_category.dart'; // for routeObserver

class UniversitiesListPage extends ConsumerStatefulWidget {
  final String categoryName;
  final String categoryId;
  final List<University> universities;

  const UniversitiesListPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.universities,
  });

  @override
  ConsumerState<UniversitiesListPage> createState() =>
      _UniversitiesListPageState();
}

class _UniversitiesListPageState extends ConsumerState<UniversitiesListPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dataProvider).fetchAll();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    ref.read(dataProvider).fetchAll(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.universities.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, uniIndex) {
            final university = widget.universities[uniIndex];
            final courseCount = provider.courses
                .where(
                  (c) =>
                      c.universityId == university.universityId &&
                      (c.categoryId ?? 'uncategorized') == widget.categoryId,
                )
                .length;

            return UniversityCard(
              universityName: university.universityName,
              courseCount: courseCount,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CoursesGridPage(
                      title: university.universityName,
                      courses: provider.courses
                          .where(
                            (c) =>
                                c.universityId == university.universityId &&
                                (c.categoryId ?? 'uncategorized') ==
                                    widget.categoryId,
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
