import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shoppingm8_fe/auth/dto/loginDto.dart';
import 'package:shoppingm8_fe/auth/dto/registrationDto.dart';
import 'package:shoppingm8_fe/auth/dto/socialMediaLoginDto.dart';
import 'package:shoppingm8_fe/common/ApiProvider.dart';

import '../main.dart';
import 'dto/refreshTokenDto.dart';

class AuthenticationApiProvider extends ApiProvider {
  static final String _authenticationEndpoint = "auth";
  static final String _loginEndpoint = "login";
  static final String _refreshEndpoint = "refresh";
  static final String _registerEndpoint = "register";
  static final String _meEndpoint = "me";

  AuthenticationApiProvider() {
    dio = new Dio();
    dio.options.connectTimeout = 2000;
    this.uri = Uri.parse(serverUrl + "/" + _authenticationEndpoint + "/");
  }

  Future<http.StreamedResponse> register(RegistrationDto registrationDto, File profilePicture) async {
    var request = http.MultipartRequest('POST', uri.resolve(_registerEndpoint));
    request..files.add(http.MultipartFile.fromString(
      "data", jsonEncode(registrationDto),
      contentType: MediaType("application", "json"),
    ));

    if (profilePicture != null) {
      request..files.add(await http.MultipartFile.fromPath(
        "picture",
        profilePicture.path,
        contentType: MediaType("image", "jpeg"),
      ));
    }

    return request.send();
  }

  Future<Response> login(LoginDto loginDto) {
    return sendPostRequest(endpoint: _loginEndpoint, body: loginDto);
  }

  Future<Response> refresh(RefreshTokenDto refreshTokenDto) {
    return sendPostRequest(endpoint: _refreshEndpoint, body: refreshTokenDto);
  }

  Future<Response> me() async {
    return defaultDio.getUri(uri.resolve(_meEndpoint),
        options: Options(
          contentType: ContentType.json.value,
        ));
  }

  Future<Response> socialMediaLogin(String media, SocialMediaLoginDto socialMediaLoginDto) async {
    return sendPostRequest(endpoint: "$_loginEndpoint/$media", body: socialMediaLoginDto);
  }

}