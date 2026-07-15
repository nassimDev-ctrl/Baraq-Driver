import 'dart:developer' as dev;
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_service.dart';
import 'package:drever_warr/core/service/failure.dart';
import '../../model/messages_model.dart';
import 'repo.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ApiService apiService;

  ChatRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, List<ChatMessageModel>>> getMessages(String authUser) async {
    try {
      dev.log('🚀 [GET] Fetching messages for $authUser', name: 'ChatRepo');

      final response = await apiService.get(
        endpoint: '/messages/$authUser',
        needToken: true,
      );

      dev.log('✅ [Raw Response]: ${response.data}', name: 'ChatRepo');

      final data = response.data;

      List<dynamic> list = [];
      if (data is Map<String, dynamic>) {
        list = (data['data'] ?? data['messages'] ?? []) as List<dynamic>;
      } else if (data is List) {
        list = data;
      }

      final messages = list
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return right(messages);
    } catch (e) {
      dev.log('❌ [GET Error]: $e', name: 'ChatRepo', error: e);
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, ChatMessageModel>> sendMessage({
    required String authUser,
    required String message,
    required String tripId,
  }) async {
    try {
      dev.log('🚀 [SEND] Sending message to $authUser', name: 'ChatRepo');

      final response = await apiService.postdata(
       '/messages/send/$authUser',
        data: {
          "text": message,
          "tripId": tripId
        },
        isfromdata: false,
        needToken: true,
      );

      dev.log('✅ [Raw Response]: ${response.data}', name: 'ChatRepo');

      final data = response.data;
      final messageJson = data is Map<String, dynamic>
          ? (data['data'] ?? data['message'] ?? data)
          : data;

      return right(ChatMessageModel.fromJson(messageJson as Map<String, dynamic>));
    } catch (e) {
      dev.log('❌ [SEND Error]: $e', name: 'ChatRepo', error: e);
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString(), 500));
    }
  }
}