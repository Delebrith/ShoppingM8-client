import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shoppingm8_fe/main.dart';
import 'package:shoppingm8_fe/user/userDto.dart';

class UserLabelWidget extends StatefulWidget {
  final UserDto userDto;
  final double avatarRadius;
  final double fontSize;

  UserLabelWidget({Key key, this.userDto, this.avatarRadius, this.fontSize})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserLabelState(userDto, avatarRadius, fontSize);
  }
}

class _UserLabelState extends State {
  final UserDto userDto;
  final double avatarRadius;
  final double fontSize;

  String _token;
  ImageProvider _defaultImage = AssetImage("assets/user.jpg");
  ImageProvider _profilePicture;

  _UserLabelState(this.userDto, this.avatarRadius, this.fontSize) {
    _setTokenAndProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            margin: EdgeInsets.all(10),
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: avatarRadius,
                backgroundImage: _profilePicture ?? _defaultImage,
            )
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              userDto.name,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _setTokenAndProfilePicture() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    _token = await storage.read(key: "JWT_access_token");
    if (userDto.profilePicture != null) {
      setState(() {
        _profilePicture = _getProfilePicture();
      });
    }
  }

  NetworkImage _getProfilePicture() {
    return NetworkImage(serverUrl + userDto.profilePicture, headers: {"Authorization": "Bearer " + _token});
  }
}
