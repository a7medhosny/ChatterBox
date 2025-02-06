import 'package:bloc/bloc.dart';
import 'package:chatter_box/features/chat/data/models/message_model.dart';
import 'package:chatter_box/features/chat/data/repo/chat_repo.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  ChatCubit(this.chatRepo) : super(ChatInitial());
  Future<void> sendChatMessage(uid1, uid2, Message message,
      ChatUser currentUser, ChatUser otherUser) async {
    try {
      await chatRepo.sendChatMessage(uid1, uid2, message);
      List<ChatMessage> messages =
          await getChatData(uid1, uid2, currentUser, otherUser);
      emit(SendMessageSuccess(messages: messages));
    } catch (e) {
      print("Error with seding message $e");
    }
  }

  Future<List<ChatMessage>> getChatData(String uid1, String uid2,
      ChatUser currentUser, ChatUser otherUser) async {
    try {
      List<ChatMessage> messages =
          await chatRepo.getChatData(uid1, uid2, currentUser, otherUser);
      return messages;
    } catch (e) {}
    return [];
  }
}
