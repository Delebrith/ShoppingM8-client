import 'dart:io';

import 'package:flutter/material.dart';
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

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
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
                                    onPressed: getImageFromCamera,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.photo),
                                    color: Colors.lightGreen,
                                    onPressed: getImageFromGallery,
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