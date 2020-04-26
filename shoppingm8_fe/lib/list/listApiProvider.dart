import 'package:dio/dio.dart';
import 'package:shoppingm8_fe/common/ApiProvider.dart';
import 'package:shoppingm8_fe/list/dto/listRequestDto.dart';

class ListApiProvider extends ApiProvider {
  static final String listPrefix = "/list/";

  Uri uri;

  ListApiProvider({String serverUrl, Dio dio}) : super(serverUrl: serverUrl, dio: dio) {
    uri = Uri.parse(serverUrl + listPrefix);
  }

  Future<Response> getMyLists() {
    return sendGetRequest(endpoint: "my-lists");
  }

  Future<Response> getSingleList(num id) {
    return sendGetRequest(endpoint: id.toString());
  }

  Future<Response> createList(ListRequestDto dto) {
    return sendPostRequest(endpoint: "", body: dto);
  }

  Future<Response> updateList(num id, ListRequestDto dto) {
    return sendPatchRequest(endpoint: id.toString(), body: dto);
  }

  Future<Response> deleteList(num id) {
    return sendDeleteRequest(endpoint: id.toString());
  }
}