import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButtonWidget extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final Color color;
  final double radius;

  RoundButtonWidget({Key key, this.onPressed, this.icon, this.color, this.radius = 42}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: color,
        child: IconButton(
          icon: Icon(icon),
          color: Colors.white,
          onPressed: onPressed,
          iconSize: radius,
        ),
      ),
    );
  }

}