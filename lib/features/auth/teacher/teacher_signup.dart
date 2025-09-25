import 'package:azeducation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AddTeacherPage extends ConsumerStatefulWidget {
  const AddTeacherPage({super.key});

  @override
  ConsumerState<AddTeacherPage> createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends ConsumerState<AddTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _subjectsController = TextEditingController();

  bool _loading = false;

  Future<void> _signupTeacher() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await ref.read(authServiceProvider).signUpUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        mobile: _mobileController.text.trim(),
        role: "teacher",
        extraData: {
          "is_teacher": true,
          "subjects": _subjectsController.text.trim().split(","),
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Teacher signup successful!")),
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
      appBar: AppBar(title: const Text("Add Teacher")),
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
              TextFormField(controller: _subjectsController, decoration: const InputDecoration(labelText: "Subjects (comma separated)", border: OutlineInputBorder())),
              const SizedBox(height: 24),
              _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _signupTeacher, child: const Text("Sign Up Teacher")),
            ],
          ),
        ),
      ),
    );
  }
}
