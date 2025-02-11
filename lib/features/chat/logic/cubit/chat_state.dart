part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatMessagesUpdated extends ChatState {
  final List<ChatMessage> messages;

  ChatMessagesUpdated({required this.messages});
}
