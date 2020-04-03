import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class RegistrationWidget extends StatefulWidget {
  @override
  _RegistrationWidgetState createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  String _email;
  String _password;
  String _displayName;

  GlobalKey<FormState> _registrationForm = GlobalKey<FormState>();

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
                          onPressed: _register,
                        )
                      ],
                    )
                )
            )
        )
    );
  }

  void _validateInputs() {
    if (_registrationForm.currentState.validate()) {
      _registrationForm.currentState.save();
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

  Future<void> _register() async {
    _validateInputs();
    var registrationResponse = await _sendRegistrationRequest();

    if (registrationResponse.statusCode == 201)
      print("YAY");
    else
      print("NAY " + registrationResponse.toString());
  }

  Future<http.StreamedResponse> _sendRegistrationRequest() async {
    var uri = Uri.parse("http://localhost:8080/user");
    var request = http.MultipartRequest('POST', uri);
    request..files.add(await http.MultipartFile.fromString(
          "data",
          jsonEncode({
            'email': _email,
            'password': _password,
            'name': _displayName
          }),
          contentType: MediaType("application", "json"),
      ));

    if (_image != null)
      request..files.add(await http.MultipartFile.fromPath(
        "picture",
        _image.path,
        contentType: MediaType("image", "jpeg"),
      ));

    return request.send();
  }
}