// chat_repo.dart
import 'package:chatter_box/core/helpers/helper.dart';
import 'package:chatter_box/core/services/database_service.dart';
import 'package:chatter_box/core/services/notification_service.dart';
import 'package:chatter_box/features/chat/data/models/message_model.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatRepo {
  final DatabaseService databaseService;
  final NotificationService notificationService;

  ChatRepo({required this.databaseService, required this.notificationService});

  Future<void> sendChatMessage(uid1, uid2, Message message) async {
    return await databaseService.sendChatMessage(uid1, uid2, message);
  }

  Stream<List<ChatMessage>> getChatMessages(
      String uid1, String uid2, ChatUser currentUser, ChatUser otherUser) {
    String chatId = generateChatId(uid1, uid2);
    return databaseService.getChatMessagesStream(chatId).map((snapshot) {
      List<ChatMessage> chatMessages = snapshot.docs.map((doc) {
        Message message = Message.fromJson(doc.data() as Map<String, dynamic>);
        return ChatMessage(
          user: message.senderID == currentUser.id ? currentUser : otherUser,
          createdAt: message.sentAt!.toDate(),
          text: message.content!,
        );
      }).toList();
      return chatMessages;
    });
  }
  Future<void> sendFCMNotification(
      String receiverToken, title, notificationBody) async {
    await notificationService.sendFCMNotification(
        receiverToken, title, notificationBody);
  }
}
