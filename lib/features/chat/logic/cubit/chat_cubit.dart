import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:chatter_box/features/chat/data/models/message_model.dart';
import 'package:chatter_box/features/chat/data/repo/chat_repo.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  Stream<List<ChatMessage>>? chatMessagesStream;
  
  ChatCubit(this.chatRepo) : super(ChatInitial());

  void listenForMessages(String uid1, String uid2, ChatUser currentUser, ChatUser otherUser) {
    chatMessagesStream = chatRepo.getChatMessages(uid1, uid2, currentUser, otherUser);
    chatMessagesStream!.listen((messages) {
      emit(ChatMessagesUpdated(messages: messages));
    }, onError: (e, stackTrace) {
      log("Error listening to messages: $e", stackTrace: stackTrace);
    });
  }
 

  Future<void> sendChatMessage(String uid1, String uid2, Message message,
      ChatUser currentUser, ChatUser otherUser) async {
    try {
      await chatRepo.sendChatMessage(uid1, uid2, message);
    } catch (e, stackTrace) {
      log("Error sending message: $e", stackTrace: stackTrace);
    }
  }
    Future<void> sendFCMNotification(
      String receiverToken, title, notificationBody) async {
    await chatRepo.sendFCMNotification(
        receiverToken, title, notificationBody);
  }
}
