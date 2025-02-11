import 'package:chatter_box/core/services/auth_service.dart';
import 'package:chatter_box/core/services/database_service.dart';
import 'package:chatter_box/core/services/notification_service.dart';
import 'package:chatter_box/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  final AuthService authService;
  final DatabaseService databaseService;
  final NotificationService notificationService;

  AuthRepo(
      {required this.authService, required this.databaseService,required this.notificationService});

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

  Future<UserModel?> _mapFirebaseUserToUserModel(User? user) async {
    if (user == null) return null;
    String? token = await notificationService.getFCMToken();
    return UserModel(
        uid: user.uid, name: user.displayName ?? "Unknown", token: token!);
  }

  Future<void> addUser(UserModel user) async {
    return await databaseService.addUser(user);
  }
}
