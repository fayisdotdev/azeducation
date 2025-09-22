import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  // ✅ Check if user is logged in
  User? get currentUser => supabase.auth.currentUser;

  // ✅ Listen for auth state changes
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  // ✅ Login
  Future<AuthResponse> signIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // ✅ Signup
  Future<AuthResponse> signUp(String email, String password) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // ✅ Logout
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
