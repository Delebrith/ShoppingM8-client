import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../main.dart';

abstract class ApiProvider {
  Dio dio = defaultDio;
  Uri uri;

  Future<Response> sendPostRequest({String endpoint, Object body}) {
    return dio.postUri(uri.resolve(endpoint),
        data: jsonEncode(body),
        options: Options(
          contentType: ContentType.json.value,
        ));
  }

  Future<Response> sendPostMultipartRequest({String endpoint, FormData body, ContentType contentType}) {
    return dio.postUri(uri.resolve(endpoint),
        data: body,
        options: Options(
          contentType: contentType.value,
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