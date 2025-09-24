import 'package:azeducation/models/user_model.dart';
import 'package:azeducation/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azeducation/providers/auth_provider.dart';

final userServiceProvider = Provider<UserService>((ref) => UserService());

final currentUserProfileProvider = FutureProvider<UserModel?>((ref) async {
  final authUser = ref.watch(currentUserProvider).value;
  if (authUser == null) return null;

  final userService = ref.read(userServiceProvider);
  return await userService.getUserById(authUser.id);
});

