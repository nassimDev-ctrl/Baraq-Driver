import 'package:flutter_bloc/flutter_bloc.dart';


import '../../model/messages_model.dart';
import '../../repo/messages_repo/repo.dart';
import 'cubit_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;

  ChatCubit(this.chatRepository) : super(ChatInitial());

  Future<void> fetchMessages(String authUser) async {
    emit(ChatLoading());

    final result = await chatRepository.getMessages(authUser);

    result.fold(
          (failure) => emit(ChatFailure(failure.errMassage)),
          (messages) => emit(ChatLoaded(messages)),
    );
  }

  Future<void> sendMessage({
    required String authUser,
    required String message,
    required String tripId,
    required String senderId,
  }) async {
    if (message.trim().isEmpty) return;

    emit(ChatSending());

    final result = await chatRepository.sendMessage(
      authUser: authUser,
      message: message.trim(),
      tripId: tripId.trim()
    );

    result.fold(
          (failure) => emit(ChatFailure(failure.errMassage)),
          (sentMessage) => emit(ChatSendSuccess(sentMessage)),
    );
  }

  void replaceMessages(List<ChatMessageModel> messages) {
    emit(ChatLoaded(messages));
  }

  void appendMessage(ChatMessageModel message) {
    final current = state;

    if (current is ChatLoaded) {
      emit(ChatLoaded([...current.messages, message]));
    } else {
      emit(ChatLoaded([message]));
    }
  }

  void addIncomingMessage(ChatMessageModel message) {
    final current = state;
    if (current is ChatLoaded) {
      emit(ChatLoaded([...current.messages, message]));
    } else if (current is ChatSendSuccess) {
      emit(ChatLoaded([message]));
    } else {
      emit(ChatLoaded([message]));
    }
  }
}