import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class RegistartionWidget extends StatefulWidget {
  @override
  _RegistartionWidgetState createState() => _RegistartionWidgetState();
}

class _RegistartionWidgetState extends State<RegistartionWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();

  File _image;

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
                        TextField(
                          autofocus: true,
                          autocorrect: false,
                          decoration: InputDecoration(labelText: "email"),
                          controller: _emailController,
                        ),
                        TextField(
                          autofocus: false,
                          autocorrect: false,
                          decoration: InputDecoration(labelText: "password"),
                          controller: _passwordController,
                          obscureText: true,
                        ),
                        TextField(
                          autofocus: false,
                          autocorrect: false,
                          decoration: InputDecoration(labelText: "display name"),
                          controller: _displayNameController,
                          obscureText: true,
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
                                  )
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: Image(
                                  image: _image == null
                                      ? AssetImage("assets/user.jpg")
                                      : FileImage(_image),
                                  height: 350,
                                ),
                              )
                            ],
                          ),
                        ),
                        FlatButton(
                          child: Text("REGISTER"),
                          color: Colors.lightGreen,
                          onPressed: () => {print("Registartion")},
                        )
                      ],
                    )
                )
            )
        )
    );
  }

}