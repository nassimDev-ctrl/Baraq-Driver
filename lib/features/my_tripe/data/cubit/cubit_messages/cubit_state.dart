import '../../model/messages_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatLoaded extends ChatState {
  final List<ChatMessageModel> messages;
  ChatLoaded(this.messages);
}
class ChatSending extends ChatState {}
class ChatSendSuccess extends ChatState {
  final ChatMessageModel message;
  ChatSendSuccess(this.message);
}
class ChatFailure extends ChatState {
  final String errMessage;
  ChatFailure(this.errMessage);
}