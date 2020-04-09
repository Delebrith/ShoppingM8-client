import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as dio_package;
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shoppingm8_fe/auth/authenticationApiProvider.dart';
import 'package:shoppingm8_fe/auth/dto/authenticationResponseDto.dart';
import 'package:shoppingm8_fe/auth/dto/refreshTokenDto.dart';

class AuthenticationInterceptor extends dio_package.Interceptor {
  final Function onAuthenticationError;
  AuthenticationApiProvider authenticationApiProvider;
  FlutterSecureStorage secureStorage;

  AuthenticationInterceptor({this.onAuthenticationError, String serverUrl}) {
    this.authenticationApiProvider = AuthenticationApiProvider(serverUrl);
    this.secureStorage = FlutterSecureStorage();
  }

  @override
  Future onRequest(RequestOptions options) async {
    var token = await secureStorage.read(key: "JWT_access_token");
    if (token != null) {
      options.headers.addEntries([MapEntry("Authorization", "Bearer " + token)]);
    }
    return options;
  }

  @override
  Future onError(DioError err) async {
    log(err.toString());
    _refreshToken();
    Response response = await _repeatRequest(err);
    if (response.statusCode == 401) {
      onAuthenticationError();
    } else {
      return response;
    }
  }

  Future<void> _refreshToken() async {
    var token = await secureStorage.read(key: "JWT_refresh_token");
    if (token != null) {
      var refreshTokenDto = RefreshTokenDto(token);
      var authenticationResponse  = await authenticationApiProvider.refresh(refreshTokenDto);
      if (authenticationResponse.statusCode == 200) {
        _updateAccessToken(authenticationResponse);
      }
    }
  }

  void _updateAccessToken(Response response) {
    var responseBody = AuthenticationResponseDto.fromJson(response.data);
    secureStorage.write(key: "JWT_access_token", value: responseBody.accessToken);
    secureStorage.write(key: "JWT_refresh_token", value: responseBody.refreshToken);
  }

  Future<Response> _repeatRequest(DioError err) async {
    var requestOptions = err.request;
    var token = await secureStorage.read(key: "JWT_access_token");
    if (token != null) {
      requestOptions.headers.addEntries([MapEntry("Authorization", token)]);
    }

    final dio_package.Options options = dio_package.Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
      extra: requestOptions.extra,
      contentType: requestOptions.contentType,
      validateStatus: (status) => true,
    );

    var repeatDio = Dio();
    return repeatDio.request(requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options
    );
  }

}