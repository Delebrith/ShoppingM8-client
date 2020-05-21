import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shoppingm8_fe/list/dto/listResponseDto.dart';
import 'package:shoppingm8_fe/list/invitation/listInvitationsWidget.dart';
import 'package:shoppingm8_fe/list/receipt/receiptListWidget.dart';
import 'package:shoppingm8_fe/user/userApiProvider.dart';

class PushNotificationsManager {
  static final PushNotificationsManager instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final UserApiProvider _userApiProvider = UserApiProvider();
  bool _initialized = false;
  BuildContext context;

  PushNotificationsManager._();

  factory PushNotificationsManager() => instance;

  Future<void> init() async {
    if (!_initialized) {
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onLaunch: (notification) => goToScreenIfSpecified(notification['data']),
        onResume: (notification) => goToScreenIfSpecified(notification['data'])
      );
      _firebaseMessaging.onTokenRefresh.listen((token) async => await updateTokenIfNecessary(token));

      String token = await _firebaseMessaging.getToken();
      await updateTokenIfNecessary(token);

      _initialized = true;
    }
  }

  Future<void> goToScreenIfSpecified(data) {
    var screen = data['screen'];
    if (screen == "INVITATIONS") {
      var invitationsRouteBuilder = (context) => ListInvitationsWidget();
      return popAllAndGoTo(invitationsRouteBuilder);
    } else if (screen == "RECEIPTS") {
      var listDto = ListResponseDto.fromJson(jsonDecode(data['list']));
      var receiptsRouteBuilder = (context) => ReceiptListWidget(listDto: listDto,);
      return popAllAndGoTo(receiptsRouteBuilder);
    }
    return null;
  }

  Future<void> popAllAndGoTo(Function routeBuilder) {
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    return Navigator.push(this.context, MaterialPageRoute(builder: routeBuilder));
  }

  Future<void> updateTokenIfNecessary(String token) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    var previousToken = await storage.read(key: "fcm-token");
    if (previousToken != token) {
      storage.write(key: "fcm-token", value: token);
      _userApiProvider.updateFcmToken(token);
    }
  }
}