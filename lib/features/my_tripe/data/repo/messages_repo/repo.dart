import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
import '../../model/messages_model.dart';

abstract class ChatRepository {
  Future<Either<Failur, List<ChatMessageModel>>> getMessages(String authUser);

  Future<Either<Failur, ChatMessageModel>> sendMessage({
    required String authUser,
    required String message,
    required String tripId,
  });
}