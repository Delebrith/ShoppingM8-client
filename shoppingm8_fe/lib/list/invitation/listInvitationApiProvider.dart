import 'package:dio/dio.dart';
import 'package:shoppingm8_fe/common/ApiProvider.dart';

import '../../main.dart';

class ListInvitationApiProvider extends ApiProvider {
  static final String listPrefix = "/list-invitation/";

  Uri uri;

  ListInvitationApiProvider() : super() {
    uri = Uri.parse(serverUrl + listPrefix);
  }

  Future<Response> getMyInvitations() {
    return sendGetRequest(endpoint: "my-invitations");
  }

  Future<Response> acceptInvitation(num id) {
    return sendPostRequest(endpoint: id.toString(), body: "");
  }

  Future<Response> rejectInvitation(num id) {
    return sendDeleteRequest(endpoint: id.toString());
  }

  Future<Response> withdrawInvitation(num id) {
    return sendDeleteRequest(endpoint: id.toString() + "/withdraw");
  }
}