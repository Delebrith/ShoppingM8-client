import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButtonWidget extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final Color color;

  const RoundButtonWidget({Key key, this.onPressed, this.icon, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: CircleAvatar(
        radius: 42,
        backgroundColor: color,
        child: IconButton(
          icon: Icon(icon),
          color: Colors.white,
          onPressed: onPressed,
          iconSize: 40,
        ),
      ),
    );
  }

}