import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  User? get currentUser => supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  Future<AuthResponse> signIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  /// Generic signup for any role
  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
    required String mobile,
    required String role,
    Map<String, dynamic>? extraData,
  }) async {
    // 1. Create auth user
    final authRes = await signUp(email, password);
    final user = authRes.user;
    if (user == null) throw "Signup failed";

    // 2. Insert into users table
    final insertData = {
      "id": user.id,
      "name": name,
      "email": email,
      "password": password,
      "mobile": mobile,
      "role": role,
      ...?extraData, // merge extra fields (is_admin, subjects, courses, etc)
    };

    await supabase.from("users").insert(insertData);
  }
}
