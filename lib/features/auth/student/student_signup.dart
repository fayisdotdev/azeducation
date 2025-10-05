import 'package:azeducation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentSignupPage extends ConsumerStatefulWidget {
  const StudentSignupPage({super.key});

  @override
  ConsumerState<StudentSignupPage> createState() => _StudentSignupPageState();
}

// ...existing imports...

class _StudentSignupPageState extends ConsumerState<StudentSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();

  bool _loading = false;
  List<Map<String, dynamic>> _coreSubjects = [];
  String? _selectedCoreSubjectId;

  @override
  void initState() {
    super.initState();
    _fetchCoreSubjectsWithStreams();
  }

  Future<void> _fetchCoreSubjectsWithStreams() async {
    try {
      final supabase = Supabase.instance.client;
      // Join core_subjects with streams to get stream name
      final response = await supabase
          .from("core_subjects")
          .select("core_id, subject_name, stream_id, streams(stream_name)");
      setState(() {
        _coreSubjects = (response as List).cast<Map<String, dynamic>>();
      });
    } catch (e) {
      debugPrint("Error fetching core subjects: $e");
    }
  }

  Future<void> _signupStudent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCoreSubjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a core subject")));
      return;
    }

    setState(() => _loading = true);

    try {
      await ref.read(authServiceProvider).signUpUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        mobile: _mobileController.text.trim(),
        role: "student",
        extraData: {
          "is_student": true,
          "core_subject_id": _selectedCoreSubjectId,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed: $e")),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Student")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Name", border: OutlineInputBorder()), validator: (val) => val!.isEmpty ? "Enter name" : null),
              const SizedBox(height: 16),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()), validator: (val) => val!.isEmpty ? "Enter email" : null),
              const SizedBox(height: 16),
              TextFormField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()), validator: (val) => val!.isEmpty ? "Enter password" : null),
              const SizedBox(height: 16),
              TextFormField(controller: _mobileController, decoration: const InputDecoration(labelText: "Mobile", border: OutlineInputBorder()), validator: (val) => val!.isEmpty ? "Enter mobile" : null),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCoreSubjectId,
                hint: const Text("Select Core Subject"),
                items: _coreSubjects.map((c) {
                  final streamName = c["streams"]?["stream_name"] ?? "";
                  return DropdownMenuItem(
                    value: c["core_id"] as String,
                    child: Text("${c["subject_name"]} (${streamName})"),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCoreSubjectId = val),
                decoration: const InputDecoration(labelText: "Core Subject", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _signupStudent, child: const Text("Sign Up Student")),
            ],
          ),
        ),
      ),
    );
  }
}