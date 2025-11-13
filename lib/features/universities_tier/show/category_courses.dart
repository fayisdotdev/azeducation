// import 'package:azeducation/features/auth/login_page.dart';
// import 'package:azeducation/features/universities_tier/add/add_courses.dart';
// import 'package:azeducation/features/universities_tier/show/show_mixed.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:azeducation/features/universities_tier/university_model.dart';
// import 'package:azeducation/features/auth/student/student_signup.dart';

// class CoursesByCategoryPage extends ConsumerStatefulWidget {
//   const CoursesByCategoryPage({super.key});

//   @override
//   ConsumerState<CoursesByCategoryPage> createState() =>
//       _CoursesByCategoryPageState();
// }

// class _CoursesByCategoryPageState extends ConsumerState<CoursesByCategoryPage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(dataProvider).fetchAll();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = ref.watch(dataProvider);

//     if (provider.isLoading && !provider.hasLoaded) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     final Map<String, List<Course>> groupedCourses = {};
//     for (var course in provider.courses) {
//       final categoryId = course.categoryId ?? 'uncategorized';
//       groupedCourses.putIfAbsent(categoryId, () => []).add(course);
//     }

//     String getCategoryName(String id) {
//       if (id == 'uncategorized') return 'Uncategorized';
//       return provider.categories
//           .firstWhere(
//             (c) => c.categoryId == id,
//             orElse: () => CourseCategory(
//               categoryId: id,
//               categoryName: 'Unknown',
//               createdAt: DateTime.now(),
//             ),
//           )
//           .categoryName;
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Courses by Categories"),
//         actions: [
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.more_vert),
//             onSelected: (value) {
//               if (value == 'login') {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const LoginPage()),
//                 );
//               } else if (value == 'signup') {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const StudentSignupPage()),
//                 );
//               }
//             },
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: 'login',
//                 child: ListTile(
//                   leading: Icon(Icons.login_outlined),
//                   title: Text('Login'),
//                 ),
//               ),
//               const PopupMenuItem(
//                 value: 'signup',
//                 child: ListTile(
//                   leading: Icon(Icons.person_add_alt_1_outlined),
//                   title: Text('Signup'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () => ref.read(dataProvider).fetchAll(forceRefresh: true),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: GridView.builder(
//             itemCount: groupedCourses.keys.length,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 1,
//             ),
//             itemBuilder: (context, index) {
//               final categoryId = groupedCourses.keys.elementAt(index);
//               final categoryName = getCategoryName(categoryId);
//               final courses = groupedCourses[categoryId]!;

//               return Card(
//                 elevation: 3,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => CoursesGridPage(
//                           title: categoryName,
//                           courses: courses,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.category_outlined,
//                             size: 40,
//                             color: Colors.blue,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             categoryName,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text("${courses.length} courses"),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
