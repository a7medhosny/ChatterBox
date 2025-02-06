import 'package:chatter_box/core/services/database_service.dart';
import 'package:chatter_box/features/chat/data/models/message_model.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatRepo {
  final DatabaseService databaseService;

  ChatRepo({required this.databaseService});
  Future<void> sendChatMessage(uid1, uid2, Message message) async {
    return await databaseService.sendChatMessage(uid1, uid2, message);
  }

  Future<List<ChatMessage>> getChatData(String uid1, String uid2,ChatUser currentUser,ChatUser otherUser) async {
    try {
      final chat = await databaseService.getChatData(uid1, uid2);
      List<Message> messages = chat.messages!;
      List<ChatMessage> chatMessages = messages
          .map((message) => ChatMessage(
              user: message.senderID == currentUser.id
                  ? currentUser
                  : otherUser,
              createdAt: message.sentAt!.toDate(),
              text: message.content!))
          .toList();
      chatMessages.sort((a, b) {
        return b.createdAt.compareTo(a.createdAt);
      });
      return chatMessages;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
