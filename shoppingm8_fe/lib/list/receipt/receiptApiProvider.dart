import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shoppingm8_fe/common/ApiProvider.dart';

import '../../main.dart';

class ReceiptApiProvider extends ApiProvider {
  final num id;

  ReceiptApiProvider({this.id}) : super() {
    this.uri = Uri.parse(serverUrl + "/list/$id/receipt/");
  }

  Future<Response> getListsReceipts() {
    return sendGetRequest(endpoint: "");
  }

  Future<Response> createReceipt(String filePath) async {
    return sendPostMultipartRequest(
        endpoint: "",
        body: FormData.fromMap({"picture" : await MultipartFile.fromFile(filePath)}),
        contentType: ContentType.parse("image/jpeg")
    );
  }
}