import 'package:dio/dio.dart';
import 'package:shoppingm8_fe/common/ApiProvider.dart';

import '../main.dart';
import 'dto/fcmTokenDto.dart';

class UserApiProvider extends ApiProvider {
  static final String listPrefix = "/user/";

  Uri uri;

  UserApiProvider() : super() {
    uri = Uri.parse(serverUrl + listPrefix);
  }

  Future<Response> getUsers(int pageSize, int pageNo, String name) {
    return sendGetRequest(endpoint: "?pageSize=$pageSize&pageNo=$pageNo&name=$name");
  }

  Future<Response> updateFcmToken(String token) {
    return sendPostRequest(endpoint: "me/fcm-token", body: FcmTokenDto(token: token));
  }
}