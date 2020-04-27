import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

abstract class ApiProvider {
  final Dio dio;
  final String serverUrl;
  Uri uri;

  ApiProvider({this.dio, this.serverUrl});

  Future<Response> sendPostRequest({String endpoint, Object body}) {
    return dio.postUri(uri.resolve(endpoint),
        data: jsonEncode(body),
        options: Options(
          contentType: ContentType.json.value,
        ));
  }

  Future<Response> sendPatchRequest({String endpoint, Object body}) {
    return dio.patchUri(uri.resolve(endpoint),
        data: jsonEncode(body),
        options: Options(
          contentType: ContentType.json.value,
        ));
  }

  Future<Response> sendGetRequest({String endpoint}) {
    return dio.getUri(uri.resolve(endpoint),
        options: Options(
          contentType: ContentType.json.value,
        ));
  }

  Future<Response> sendDeleteRequest({String endpoint}) {
    return dio.deleteUri(uri.resolve(endpoint),
        options: Options(
          contentType: ContentType.json.value,
        ));
  }
}