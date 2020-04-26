import 'package:dio/dio.dart';
import 'package:shoppingm8_fe/common/ApiProvider.dart';

import 'dto/productRequestDto.dart';

class ProductApiProvider extends ApiProvider {
  static const String base_endpoint = "/list/{id}/product/";
  final num id;

  ProductApiProvider({this.id, String serverUrl, Dio dio}) : super(serverUrl: serverUrl, dio: dio) {
    this.uri = Uri.parse("/list/$id/product/");
  }

  Future<Response> getListsProducts() {
    return sendGetRequest(endpoint: "");
  }

  Future<Response> getSingleProduct(num id) {
    return sendGetRequest(endpoint: id.toString());
  }

  Future<Response> createProduct(ProductRequestDto dto) {
    return sendPostRequest(endpoint: "", body: dto);
  }

  Future<Response> updateProduct(num id, ProductRequestDto dto) {
    return sendPatchRequest(endpoint: id.toString(), body: dto);
  }

  Future<Response> purchaseProduct(num id, num amountPurchased) {
    return sendPostRequest(endpoint: id.toString() + "?purchased=$amountPurchased", body: "");
  }

  Future<Response> deleteProduct(num id) {
    return sendDeleteRequest(endpoint: id.toString());
  }
}