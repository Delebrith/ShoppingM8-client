import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingm8_fe/user/userDto.dart';

class UserLabelWidget extends StatelessWidget {
  final UserDto userDto;
  final double avatarRadius;
  final double fontSize;

  UserLabelWidget({Key key, this.userDto, this.avatarRadius, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            margin: EdgeInsets.all(10),
            child: CircleAvatar(
                backgroundImage: AssetImage("assets/user.jpg"),
                backgroundColor: Colors.transparent,
                radius: avatarRadius,
                child: Image(
                  image: NetworkImage(userDto.profilePicture),
                )
            )
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              userDto.name,
              style: TextStyle(
                fontSize: fontSize
              ),
            ),
          ),
        )
      ],
    );
  }

}