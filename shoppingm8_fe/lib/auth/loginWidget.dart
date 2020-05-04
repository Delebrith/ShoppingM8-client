import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shoppingm8_fe/auth/authenticationApiProvider.dart';
import 'package:shoppingm8_fe/auth/dto/authenticationResponseDto.dart';
import 'package:shoppingm8_fe/auth/dto/loginDto.dart';
import 'package:shoppingm8_fe/auth/dto/socialMediaLoginDto.dart';
import 'package:shoppingm8_fe/auth/registrationWidget.dart';
import 'package:shoppingm8_fe/common/dto/errorDto.dart';
import 'package:shoppingm8_fe/menu/mainMenuWidget.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  String _email;
  String _password;

  AuthenticationApiProvider authenticationApiProvider = AuthenticationApiProvider();
  
  final _googleSignIn = new GoogleSignIn(scopes: ['email']);
  final _facebookSignIn = FacebookLogin();

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
              child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Title(
                      color: Colors.black,
                      child: Text(
                          "Sign in to your ShoppingM8!",
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
                        child: Text("SIGN IN"),
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
                                  Expanded(
                                    child: Text(
                                      "Sign in with Google",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                              onPressed: _googleLogin,
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
                                  Expanded(
                                    child: Text(
                                      "Sign in with Facebook",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                              onPressed: _facebookLogin,
                            ),
                          ),
                        ],
                      )
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Flex(
                        direction: Axis.vertical,
                        verticalDirection: VerticalDirection.down,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                              "Don't have the account yet?",
                            style: TextStyle(
                              color: Colors.black26
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.all(5),
                              child: FlatButton(
                                child: Text("REGISTER"),
                                color: Colors.lightGreen,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RegistrationWidget())
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
              )
            ),
          )
        ],
      )
    );
  }

  void _googleLogin() async {
    final result = await _googleSignIn.signIn();
    if (_googleSignIn.currentUser != null) {
      final auth = await result.authentication;
      final token = auth.accessToken;
      await _socialMediaLogin("google", token);
    }
  }

  void _facebookLogin() async {
    final result = await _facebookSignIn.logIn(["email"]);
    if (result.status == FacebookLoginStatus.loggedIn) {
      final token = result.accessToken.token;
      await _socialMediaLogin("facebook", token);
    }
  }

  Future<void> _socialMediaLogin(String media, String token) async {
    Response loginResponse = await authenticationApiProvider.socialMediaLogin(media, SocialMediaLoginDto(token: token));
    finalizeLogin(loginResponse);
  }

  void _login() async {
    _loginForm.currentState.save();
    Response loginResponse = await authenticationApiProvider.login(LoginDto(email: _email, password: _password));
    finalizeLogin(loginResponse);
  }

  void finalizeLogin(Response loginResponse) {
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenuWidget()));
  }

  _onLoginError(Response response) {
    var responseBody = ErrorDto.fromJson(response.data);
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