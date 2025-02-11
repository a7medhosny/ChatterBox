import 'package:chatter_box/core/services/database_service.dart';
import 'package:chatter_box/features/auth/data/models/user_model.dart';

class HomeRepo {
  final DatabaseService databaseService;

  HomeRepo({required this.databaseService});
  getUsersExceptCurrent() async {
    try {
      final docs = await databaseService.getUsersExceptCurrent();
      List<UserModel> users = docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return users;
    } catch (e) {
      print("Error getting users: $e");
      throw Exception(e.toString());
    }
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    return await databaseService.createNewChat(uid1, uid2);
  }
  Stream<Map<String,dynamic>?> getLastMessage(String chatId) {
  return databaseService.getLastMessage(chatId);
}


 
}
