import 'package:chatter_box/core/services/auth_service.dart';
import 'package:chatter_box/core/services/database_service.dart';
import 'package:chatter_box/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  final AuthService authService;
  final DatabaseService databaseService;

  AuthRepo({required this.authService, required this.databaseService});

  Future<UserModel?> login(
      {required String email, required String password}) async {
    final user = await authService.login(email, password);
    return _mapFirebaseUserToUserModel(user);
  }

  Future<UserModel?> register(
      {required String email, required String password}) async {
    final user = await authService.register(email, password);
    return _mapFirebaseUserToUserModel(user);
  }

  UserModel? _mapFirebaseUserToUserModel(User? user) {
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      name: user.displayName ?? "Unknown",
    );
  }

  Future<void> addUser(UserModel user) async {
    return await databaseService.addUser(user);
  }

}
