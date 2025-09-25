import 'package:azeducation/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Get the full user profile by auth user id
  Future<UserModel?> getUserById(String id) async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('id', id)
          .single();

      // Determine role and return proper class
      if (response['is_admin'] == true) return Admin.fromMap(response);
      if (response['is_teacher'] == true) return Teacher.fromMap(response);
      if (response['is_student'] == true) return Student.fromMap(response);

      // fallback
      return UserModel.fromMap(response);
    } catch (e) {
      debugPrint("error fetching user profile: $e");
      return null;
    }
  }
}
