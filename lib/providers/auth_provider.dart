import 'package:azeducation/services/auth_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Auth state provider (stream)
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.read(authServiceProvider).currentUser;
});
