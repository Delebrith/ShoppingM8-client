import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String title;
  final Color color;

  const MenuButton({Key key, this.onPressed, this.icon, this.title, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircleAvatar(
            radius: 45,
            backgroundColor: color,
            child: IconButton(
              icon: Icon(icon),
              color: Colors.white,
              onPressed: onPressed,
              iconSize: 40,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Title(
                color: Colors.black,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 19),
                )
            ),
          )
        ],
      ),
    );
  }
}