// ignore_for_file: constant_identifier_names
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:drever_warr/core/cash/preferences_servis.dart';

class ApiService {
  static const _baseURL = 'https://api.taxiwaar.com/';
  static const int sendTimeOut = 60;
  static const int reciveTimeOut = 60;
  static const int sendTimeOutFormData = 300;
  final Dio dio;
  ApiService(this.dio);

  Future<String> _getCurrentLanguageCode() async {
    final dynamic savedLanguage = await CacheManager.getData('app_language');

    final lang = savedLanguage?.toString().toLowerCase();

    switch (lang) {
      case 'ar':
      case 'arabic':
        return 'ar';
      case 'ku':
      case 'kurdish':
        return 'ku';
      case 'en':
      case 'english':
      default:
        return 'ar';
    }
  }

  Future<Options?> _preparationOptionsRequest(
    bool needToken, {
    bool isFormData = false,
  }) async {
    Map<String, dynamic>? header = {};


    header["Accept-Language"] = await _getCurrentLanguageCode();

    if (needToken) {
      final token = await CacheManager.getData('token');
      if (token != null && token.toString().trim().isNotEmpty) {
        header["Authorization"] = token.toString().startsWith("Bearer ")
            ? token.toString()
            : "Bearer ${token.toString().trim()}";
      }
    }

    String content = (isFormData) ? 'multipart/form-data' : 'application/json';

    return Options(
      contentType: content,
      headers: header,
      receiveTimeout: Duration(seconds: reciveTimeOut),
      sendTimeout: Duration(
        seconds: isFormData ? sendTimeOutFormData : sendTimeOut,
      ),
    );
  }

  Future<dynamic> get({
    required String endpoint,
    required bool needToken,
    bool? needTimeZone,
  }) async {
    Response response = await dio.get(
      "$_baseURL$endpoint",
      options: await _preparationOptionsRequest(needToken),
    );
    return response;
  }

  Future<dynamic> postdata(
    String endPoint, {
    dynamic data,
    required bool? needToken,
    required bool isfromdata,
    bool isFile = false,
  }) async {
    log(data.toString());
    Response response = await dio.post(
      "$_baseURL$endPoint",

      data: data,
      options: await _preparationOptionsRequest(
        needToken ?? false,
        isFormData: isfromdata,
      ),
    );
    return response;
  }

  Future<dynamic> put({
    required String endPoint,
    required var data,
    required bool isfromdata,
    bool isFile = false,
  }) async {
    Response response = await dio.put(
      "$_baseURL$endPoint",
      data: data,
      options: await _preparationOptionsRequest(true, isFormData: isfromdata),
    );
    return response;
  }

  Future<dynamic> delete(
    String endPoint, {
    dynamic data,
    required bool? needToken,
  }) async {
    Response response = await dio.delete(
      "$_baseURL$endPoint",
      data: data,
      options: await _preparationOptionsRequest(
        needToken ?? false,
        isFormData: false,
      ),
    );
    return response;
  }

  Future<dynamic> patch({
    required String endPoint,
    required dynamic data,
    bool isFormData = false,
  }) async {
    Response response = await dio.patch(
      "$_baseURL$endPoint",
      data: data,
      options: await _preparationOptionsRequest(true, isFormData: isFormData),
    );
    return response;
  }
}
