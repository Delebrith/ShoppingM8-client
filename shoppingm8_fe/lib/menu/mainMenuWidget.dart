import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shoppingm8_fe/auth/loginWidget.dart';
import 'package:shoppingm8_fe/list/myListsWidget.dart';

import 'menuButtonWidget.dart';

class MainMenuWidget extends StatelessWidget {
  final Function moveToFriendList = () => print("friend");
  final Function moveToAccountManagement = () => print("account");

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 255, 250),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              height: screenHeight/3,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.jpg"),
                    colorFilter:
                        ColorFilter.mode(Colors.blueGrey, BlendMode.lighten),
                    fit: BoxFit.cover),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                child: Title(
                    color: Colors.black,
                    child: Text(
                      "Welcome to ShoppingM8!",
                      style: TextStyle(fontSize: screenHeight/16),
                      textAlign: TextAlign.center,
                    )),
              )),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MenuButton(
                      title: "My lists",
                      onPressed: () => _moveToListScreen(context),
                      color: Colors.green,
                      icon: Icons.format_list_bulleted,
                    ),
                    MenuButton(
                      title: "My friends",
                      onPressed: moveToFriendList,
                      color: Colors.lightBlueAccent,
                      icon: Icons.people,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MenuButton(
                      title: "My account",
                      onPressed: moveToAccountManagement,
                      color: Colors.pinkAccent,
                      icon: Icons.person,
                    ),
                    MenuButton(
                      title: "Logout",
                      onPressed: () => _logout(context),
                      color: Colors.orange,
                      icon: Icons.exit_to_app,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 50),
          )
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    var storage = FlutterSecureStorage();
    await storage.delete(key: "JWT_access_token");
    await storage.delete(key: "JWT_refresh_token");
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => LoginWidget()
    ));
  }

  _moveToListScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => MyListsWidget()
    ));
  }
}
