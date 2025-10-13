import 'package:azeducation/features/universities_tier/add/add_university.dart';
import 'package:azeducation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentSignupPage extends ConsumerStatefulWidget {
  const StudentSignupPage({super.key});

  @override
  ConsumerState<StudentSignupPage> createState() =>
      _StudentSignupPageState();
}

class _StudentSignupPageState
    extends ConsumerState<StudentSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();

  bool _loading = false;
  String? _selectedCourseId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dataProvider).fetchAll(); // fetch universities & courses
    });
  }

  Future<void> _signupStudent() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCourseId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a course")));
      return;
    }

    setState(() => _loading = true);

    try {
      await ref
          .read(authServiceProvider)
          .signUpUser(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            mobile: _mobileController.text.trim(),
            role: "student",
            extraData: {
              "is_student": true,
              "courses": [_selectedCourseId], // store selected course in array
            },
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Student signup successful!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Signup failed: $e")));
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Student"),),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val!.isEmpty ? "Enter name" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val!.isEmpty ? "Enter email" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? "Enter password" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _mobileController,
                      decoration: const InputDecoration(
                        labelText: "Mobile",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val!.isEmpty ? "Enter mobile" : null,
                    ),
                    const SizedBox(height: 16),

                    // ===== Course Dropdown (with University) =====
                    DropdownButtonFormField<String>(
                      value: _selectedCourseId,
                      hint: const Text("Select Course (University)"),
                      items: provider.courses.map((course) {
                        final university = provider.universities.firstWhere(
                          (u) => u.universityId == course.universityId,
                        );
                        return DropdownMenuItem(
                          value: course.courseId,
                          child: Text(
                            "${course.courseName} (${university.universityName})",
                          ),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedCourseId = val),
                      decoration: const InputDecoration(
                        labelText: "Course (University)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _signupStudent,
                            child: const Text("Sign Up Student"),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
