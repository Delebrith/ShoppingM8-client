import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shoppingm8_fe/auth/authenticationApiProvider.dart';
import 'package:shoppingm8_fe/auth/dto/registrationDto.dart';
import 'package:shoppingm8_fe/common/dto/errorDto.dart';
import 'package:shoppingm8_fe/main.dart';
import 'package:shoppingm8_fe/menu/mainMenuWidget.dart';

import 'dto/authenticationResponseDto.dart';

class RegistrationWidget extends StatefulWidget {
  @override
  _RegistrationWidgetState createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  GlobalKey<FormState> _registrationForm = GlobalKey<FormState>();
  AuthenticationApiProvider authenticationApiProvider = AuthenticationApiProvider();

  String _email;
  String _password;
  String _displayName;
  File _image;
  var _autovalidate = false;

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    var croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Crop picture"
        ),
        iosUiSettings: IOSUiSettings(
          title: "Crop picture"
        )
    );


    setState(() {
      _image = croppedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Center(
                child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Title(
                            color: Colors.black,
                            child: Text("Please, fill your data", style: TextStyle(fontSize: 24),)),
                        Form(
                          key: _registrationForm,
                          autovalidate: _autovalidate,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                autofocus: true,
                                autocorrect: false,
                                decoration: InputDecoration(labelText: "email"),
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (value) => _email = value,
                                validator: _emailValidator,
                              ),
                              TextFormField(
                                autofocus: false,
                                autocorrect: false,
                                decoration: InputDecoration(labelText: "password"),
                                obscureText: true,
                                onSaved: (value) => _password = value,
                                validator: _passwordValidator,
                              ),
                              TextFormField(
                                autofocus: false,
                                autocorrect: false,
                                decoration: InputDecoration(labelText: "display name"),
                                onSaved: (value) => _displayName = value,
                                validator: _displayNameValidator,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    "Choose your profile picture",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.black38
                                    ),
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    color: Colors.lightGreen,
                                    onPressed: () => getImage(ImageSource.camera),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.photo),
                                    color: Colors.lightGreen,
                                    onPressed: () => getImage(ImageSource.gallery),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.cancel),
                                    color: Colors.lightGreen,
                                    onPressed: () => setState(() {_image = null;}),
                                  )
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: Image(
                                  image: _image == null
                                      ? AssetImage("assets/user.jpg")
                                      : FileImage(_image),
                                ),
                              )
                            ],
                          ),
                        ),
                        FlatButton(
                          child: Text("REGISTER"),
                          color: Colors.lightGreen,
                          onPressed: _submit,
                        )
                      ],
                    )
                )
            )
        )
    );
  }

  void _submit() {
    if (_registrationForm.currentState.validate()) {
      _registrationForm.currentState.save();
      _register();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  String _passwordValidator(String value) {
    return value.length < 8
      ? "Password must bu at least 8 characters long"
      : null;
  }

  String _displayNameValidator(String value) {
    return value.isEmpty
      ? "Display name must be filled"
      : null;
  }

  String _emailValidator(String value) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return !RegExp(pattern).hasMatch(value)
        ? "Enter valid email address"
        : null;
  }

  void _register() async {
    http.StreamedResponse response = await authenticationApiProvider.register(
        RegistrationDto(_email, _password, _displayName),
        _image
    );
    if (response.statusCode == 201) {
      var storage = FlutterSecureStorage();
      var responseBody = AuthenticationResponseDto.fromJson(jsonDecode(await response.stream.bytesToString()));
      storage.write(key: "JWT_access_token", value: responseBody.accessToken);
      storage.write(key: "JWT_refresh_token", value: responseBody.refreshToken);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MainMenuWidget()));
    } else {
      var body = await response.stream.bytesToString();
      showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Could not register"),
            content: new Text(ErrorDto.fromJson(json.decode(body)).message),
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

}