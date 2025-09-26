// import 'package:azeducation/features/home/home_page.dart';
// import 'package:azeducation/providers/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SignupPage extends ConsumerStatefulWidget {
//   const SignupPage({super.key});

//   @override
//   ConsumerState<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends ConsumerState<SignupPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _loading = false;

//   Future<void> _signup() async {
//     setState(() => _loading = true);
//     try {
//       final auth = ref.read(authServiceProvider);
//       await auth.signUp(
//         _emailController.text.trim(),
//         _passwordController.text.trim(),
//       );
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const HomePage()),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Signup failed: $e")),
//       );
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Signup")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
//             TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
//             const SizedBox(height: 20),
//             _loading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(onPressed: _signup, child: const Text("Signup")),
//           ],
//         ),
//       ),
//     );
//   }
// }
