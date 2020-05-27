import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPopupMenuItem extends PopupMenuItem {
  final Function value;
  final String title;
  final Color color;
  final IconData iconData;

  CustomPopupMenuItem(
      {Key key, this.value, this.title, this.color, this.iconData})
      : super(
          key: key,
          value: value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: color,
                  child: Icon(
                    iconData,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(title),
              )
            ],
          ),
        );
}
