import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/providers/auth_provider.dart';
import 'package:azeducation/features/auth/login_page.dart';

class AuthGuardService {
  static Future<bool> checkLoggedIn(BuildContext context, WidgetRef ref) async {
    final auth = ref.read(authServiceProvider);
    final user = auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'You haven\'t logged in. Please login to view subjects.',
          ),
          action: SnackBarAction(
            label: 'Login',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ),
      );
      return false;
    }
    return true;
  }
}
