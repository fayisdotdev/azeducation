import 'package:azeducation/features/universities_tier/add/add_university.dart';
import 'package:azeducation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentSignupPage extends ConsumerStatefulWidget {
  const StudentSignupPage({super.key});

  @override
  ConsumerState<StudentSignupPage> createState() => _StudentSignupPageState();
}

class _StudentSignupPageState extends ConsumerState<StudentSignupPage> {
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
      ref.read(dataProvider).fetchAll();
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
              "courses": [_selectedCourseId],
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final provider = ref.watch(dataProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Student Signup")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 420,
                        minWidth: constraints.maxWidth < 500
                            ? constraints.maxWidth
                            : 320,
                      ),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Create Student Account",
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Sign up to access courses and resources",
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onBackground.withOpacity(
                                      0.7,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 28),
                                ...[
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: "Full Name",
                                      prefixIcon: Icon(Icons.person_outline),
                                    ),
                                    validator: (v) => v == null || v.isEmpty
                                        ? "Enter your name"
                                        : null,
                                  ),
                                  const SizedBox(height: 18),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      labelText: "Email",
                                      prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                    validator: (v) => v == null || v.isEmpty
                                        ? "Enter your email"
                                        : null,
                                  ),
                                  const SizedBox(height: 18),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: "Password",
                                      prefixIcon: Icon(Icons.lock_outline),
                                    ),
                                    validator: (v) => v == null || v.isEmpty
                                        ? "Enter your password"
                                        : null,
                                  ),
                                  const SizedBox(height: 18),
                                  TextFormField(
                                    controller: _mobileController,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                      labelText: "Mobile Number",
                                      prefixIcon: Icon(Icons.phone_outlined),
                                    ),
                                    validator: (v) => v == null || v.isEmpty
                                        ? "Enter your mobile number"
                                        : null,
                                  ),
                                  const SizedBox(height: 18),
                                  DropdownButtonFormField<String>(
                                    value: _selectedCourseId,
                                    isExpanded: true,
                                    items: provider.courses
                                        .map(
                                          (c) => DropdownMenuItem(
                                            value: c.courseId,
                                            child: Text(
                                              c.courseName,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: _loading
                                        ? null
                                        : (v) => setState(
                                            () => _selectedCourseId = v,
                                          ),
                                    decoration: const InputDecoration(
                                      labelText: "Select Course",
                                      prefixIcon: Icon(Icons.school_outlined),
                                    ),
                                    validator: (v) =>
                                        v == null ? "Select a course" : null,
                                  ),
                                  const SizedBox(height: 28),
                                  ElevatedButton(
                                    onPressed: _loading ? null : _signupStudent,
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(48),
                                    ),
                                    child: _loading
                                        ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text("Sign Up"),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
