part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class SendMessageSuccess extends ChatState {
 final List<ChatMessage> messages;

  SendMessageSuccess({required this.messages});
}
