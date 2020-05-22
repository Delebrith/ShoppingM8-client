import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shoppingm8_fe/auth/authenticationApiProvider.dart';
import 'package:shoppingm8_fe/auth/authenticationInterceptor.dart';
import 'package:shoppingm8_fe/common/pushNotificationManager.dart';
import 'package:shoppingm8_fe/menu/mainMenuWidget.dart';

import 'auth/loginWidget.dart';

String serverUrl = "https://shopping-m8.herokuapp.com";
Dio defaultDio = Dio();
PushNotificationsManager pushNotificationsManager = PushNotificationsManager.instance;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShoppingM8',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        backgroundColor: Colors.white,
        cardColor: Colors.white,
        accentColor: Colors.lightGreenAccent,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.lightGreen,
          textTheme: ButtonTextTheme.normal,
          padding: EdgeInsets.all(5),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthenticationApiProvider authenticationApiProvider =
      AuthenticationApiProvider();
  Widget _startingWidget = Center();
  bool _serverResponding = false;

  _MyHomePageState() {
    defaultDio.interceptors.add(AuthenticationInterceptor(onAuthenticationError: _onAuthenticationError));
    defaultDio.interceptors.add(PrettyDioLogger(requestBody: true, requestHeader: true, responseBody: true));
    defaultDio.options.validateStatus = (status) => status < 500 && status != 401;
    defaultDio.options.connectTimeout = 5000;
    
    _setStartingWidget();
    Timer(Duration(seconds: 5), () {
      _showDialogIfServerNotResponding();
    });
    pushNotificationsManager.init();
  }

  void _showDialogIfServerNotResponding() {
    if (!_isServerResponding()) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Could not connect to server"),
              content: Text("Try again later."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Close"),
                  onPressed: () {exit(0);}
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    pushNotificationsManager.context = context;
    return _startingWidget;
  }

  void _onAuthenticationError() {
    var secureStorage = storage.FlutterSecureStorage();
    secureStorage.delete(key: "JWT_access_token");
    secureStorage.delete(key: "JWT_refresh_token");
    Navigator.push(
        this.context,
        MaterialPageRoute(
            builder: (context) => LoginWidget()));
  }

  void _setStartingWidget() async {
    try {
      var me = await authenticationApiProvider.me();
      if (me.statusCode == 200) {
        setState(() {
          _startingWidget = MainMenuWidget();
          _serverResponding = true;
        });
      }
    } on DioError catch (e) {
      print(e);
      if (e.type == DioErrorType.RESPONSE) {
        _serverResponding = true;
      }
    }
  }

  bool _isServerResponding() {
    return _serverResponding;
  }
}
