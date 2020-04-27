import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:shoppingm8_fe/auth/authenticationApiProvider.dart';
import 'package:shoppingm8_fe/auth/authenticationInterceptor.dart';
import 'package:shoppingm8_fe/menu/mainMenuWidget.dart';

import 'auth/loginWidget.dart';

String serverUrl = "http://localhost:8080";

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
  Dio dio = Dio();
  AuthenticationApiProvider authenticationApiProvider =
      AuthenticationApiProvider(serverUrl);
  Widget _startingWidget = Center();
  bool _serverResponding = false;

  _MyHomePageState() {
    dio.interceptors.add(AuthenticationInterceptor(
        serverUrl: serverUrl, onAuthenticationError: _onAuthenticationError));
    dio.options.validateStatus = (status) => status < 500 && status != 401;
    dio.options.connectTimeout = 2000;
    _setStartingWidget();
    Timer(Duration(seconds: 5), () {
      _showDialogIfServerNotResponding();
    });
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
    return _startingWidget;
  }

  void _onAuthenticationError() {
    var secureStorage = storage.FlutterSecureStorage();
    secureStorage.write(key: "JWT_access_token", value: null);
    secureStorage.write(key: "JWT_refresh_token", value: null);
    Navigator.push(
        this.context,
        MaterialPageRoute(
            builder: (context) => LoginWidget(
                  serverUrl: serverUrl,
                  dio: dio,
                )));
  }

  void _setStartingWidget() async {
    try {
      var me = await authenticationApiProvider.me(dio);
      if (me.statusCode == 200) {
        setState(() {
          _startingWidget = MainMenuWidget(
            serverUrl: serverUrl,
            dio: dio,
          );
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
