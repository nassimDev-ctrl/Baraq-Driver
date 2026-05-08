import 'dart:developer' as dev;
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import '../../model/messages_model.dart';
import 'repo.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ApiService apiService;

  ChatRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, List<ChatMessageModel>>> getMessages(String authUser) async {
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
        return left(ServierFailur.fromDioError(e));
      }
      return left(ServierFailur(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failur, ChatMessageModel>> sendMessage({
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
        return left(ServierFailur.fromDioError(e));
      }
      return left(ServierFailur(e.toString(), 500));
    }
  }
}