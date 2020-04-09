import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shoppingm8_fe/auth/authenticationApiProvider.dart';
import 'package:shoppingm8_fe/auth/dto/authenticationResponseDto.dart';
import 'package:shoppingm8_fe/auth/dto/loginDto.dart';
import 'package:shoppingm8_fe/auth/registrationWidget.dart';
import 'package:shoppingm8_fe/common/dto/errorDto.dart';
import 'package:shoppingm8_fe/menu/mainMenuWidget.dart';

class LoginWidget extends StatefulWidget {
  final String serverUrl;

  const LoginWidget({Key key, this.serverUrl}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState(serverUrl: serverUrl);
}

class _LoginWidgetState extends State<LoginWidget> {
  GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  final String serverUrl;

  String _email;
  String _password;

  AuthenticationApiProvider authenticationApiProvider;

  _LoginWidgetState({this.serverUrl}) {
    authenticationApiProvider = AuthenticationApiProvider(serverUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.cover
              ),
            ),
          ),
          Center(
            child: Card(
              margin: EdgeInsets.all(40.0),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Title(
                      color: Colors.black,
                      child: Text(
                          "Please, login to your ShoppingM8!",
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                      )
                    ),
                    Form(
                      key: _loginForm,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            autofocus: true,
                            autocorrect: false,
                            decoration: InputDecoration(labelText: "email"),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) => _email = value,
                          ),
                          TextFormField(
                            autofocus: false,
                            autocorrect: false,
                            decoration: InputDecoration(labelText: "password"),
                            obscureText: true,
                            onSaved: (value) => _password = value,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: FlatButton(
                        child: Text("LOGIN"),
                        color: Colors.lightGreen,
                        onPressed: _login,
                      )
                    ),
                    Row(
                        children: <Widget>[
                          Expanded(
                              child: Divider()
                          ),
                          Text("OR"),
                          Expanded(
                              child: Divider()
                          ),
                        ]
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: OutlineButton(
                              splashColor: Colors.grey,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Image(
                                    image: AssetImage("assets/google.png"),
                                    height: 25.0,
                                  ),
                                  Container(
                                    width: 230,
                                    child: Text(
                                      "Login with Google",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: OutlineButton(
                              splashColor: Colors.grey,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Image(
                                    image: AssetImage("assets/facebook.png"),
                                    height: 25.0,
                                  ),
                                  Container(
                                    width: 240,
                                    child: Text(
                                      "Login with Facebook",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      child: Column(
                        children: <Widget>[
                          Text(
                              "Don't have the account yet?",
                            style: TextStyle(
                              color: Colors.black26
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: FlatButton(
                                child: Text("REGISTER"),
                                color: Colors.lightGreen,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RegistrationWidget(serverUrl: serverUrl))
                                  );
                                },
                              )
                          ),
                        ],
                      ),
                    )
                  ],
                )
              )
            ),
          )
        ],
      )
    );
  }

  void _login() async {
    _loginForm.currentState.save();
    Response loginResponse = await authenticationApiProvider.login(LoginDto(email: _email, password: _password));
    if (loginResponse.statusCode == 200)  {
      _onLoginSuccess(loginResponse);
    } else {
      _onLoginError(loginResponse);
    }
  }


  void _onLoginSuccess(Response response) {
    var storage = FlutterSecureStorage();
    var responseBody = AuthenticationResponseDto.fromJson(response.data);
    storage.write(key: "JWT_access_token", value: responseBody.accessToken);
    storage.write(key: "JWT_refresh_token", value: responseBody.refreshToken);
    Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenuWidget(serverUrl: serverUrl,)));
  }

  _onLoginError(Response response) {
    var responseBody = ErrorDto.fromJson(jsonDecode(response.data));
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Could not register"),
            content: new Text(responseBody.message),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: Navigator.of(context).pop,
              )
            ],
          );
        }
    );
  }
}