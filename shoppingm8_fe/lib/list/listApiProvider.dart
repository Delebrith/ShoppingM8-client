import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shoppingm8_fe/list/dto/listRequestDto.dart';

class ListApiProvider {
  static final String listPrefix = "/list/";

  final Dio dio;
  final String serverUrl;
  Uri uri;

  ListApiProvider({this.dio, this.serverUrl}) {
    uri = Uri.parse(serverUrl + listPrefix);
  }

  Future<Response> getMyLists() {
    return _sendGetRequest("my-lists");
  }

  Future<Response> getSingleList(num id) {
    return _sendGetRequest(id.toString());
  }

  Future<Response> createList(ListRequestDto dto) {
    return _sendPostRequest("", dto);
  }

  Future<Response> updateList(num id, ListRequestDto dto) {
    return _sendPatchRequest(id.toString(), dto);
  }

  Future<Response> deleteList(num id) {
    return _sendDeleteRequest(id.toString());
  }

  Future<Response> _sendPostRequest(String endpoint, Object body) {
    return dio.postUri(uri.resolve(endpoint),
        data: jsonEncode(body),
        options: Options(
          contentType: ContentType.json.value,
        ));
  }

  Future<Response> _sendPatchRequest(String endpoint, Object body) {
    return dio.patchUri(uri.resolve(endpoint),
        data: jsonEncode(body),
        options: Options(
          contentType: ContentType.json.value,
        ));
  }

  Future<Response> _sendGetRequest(String endpoint) {
    return dio.getUri(uri.resolve(endpoint),
        options: Options(
          contentType: ContentType.json.value,
        ));
  }

  Future<Response> _sendDeleteRequest(String endpoint) {
    return dio.deleteUri(uri.resolve(endpoint),
        options: Options(
          contentType: ContentType.json.value,
        ));
  }
}