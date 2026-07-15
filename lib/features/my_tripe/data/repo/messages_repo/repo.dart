import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
import '../../model/messages_model.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatMessageModel>>> getMessages(String authUser);

  Future<Either<Failure, ChatMessageModel>> sendMessage({
    required String authUser,
    required String message,
    required String tripId,
  });
}