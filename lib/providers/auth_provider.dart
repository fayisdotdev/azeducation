import 'package:azeducation/services/auth_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Auth state provider (stream)
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
});

// Current user provider
final currentUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.read(authServiceProvider);
return authService.authStateChanges.map((state) => state.session?.user);
});
