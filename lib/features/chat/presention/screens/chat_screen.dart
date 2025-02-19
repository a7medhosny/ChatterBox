import 'package:chatter_box/core/services/auth_service.dart';
import 'package:chatter_box/features/auth/data/models/user_model.dart';
import 'package:chatter_box/features/chat/data/models/message_model.dart';
import 'package:chatter_box/features/chat/logic/cubit/chat_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatUser? currentUser, otherUser;
  final getIt = GetIt.instance;
  late AuthService _authService;
  List<ChatMessage> chatMessages = [];

  @override
  void initState() {
    super.initState();
    _authService = getIt.get<AuthService>();
    otherUser = ChatUser(id: widget.user.uid, firstName: widget.user.name);
    currentUser = ChatUser(
        id: _authService.user!.uid, firstName: _authService.user!.displayName);
    _listenForMessages();
  }

  void _listenForMessages() {
    context.read<ChatCubit>().listenForMessages(
          widget.user.uid,
          _authService.user!.uid,
          currentUser!,
          otherUser!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatMessagesUpdated) {
            chatMessages = state.messages;
          }
          return _buildUI();
        },
      ),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(
        alwaysShowSend: true,
      ),
      messageOptions: MessageOptions(
        showTime: true,
      ),
      currentUser: currentUser!,
      onSend: _sendMessage,
      messages: chatMessages,
    );
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    if (!context.read<ChatCubit>().isClosed) {
      Message message = Message(
        senderID: currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: Timestamp.fromDate(chatMessage.createdAt),
      );
      context.read<ChatCubit>().sendChatMessage(widget.user.uid,
          _authService.user!.uid, message, currentUser!, otherUser!);
      context.read<ChatCubit>().sendFCMNotification(
          widget.user.token, widget.user.name, chatMessage.text);
    }
  }
}
