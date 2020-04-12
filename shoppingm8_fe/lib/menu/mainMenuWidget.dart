import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shoppingm8_fe/auth/loginWidget.dart';

import 'menuButtonWidget.dart';

class MainMenuWidget extends StatelessWidget {
  final String serverUrl;
  final Function moveToListScreen = () => print("lists");
  final Function moveToFriendList = () => print("friend");
  final Function moveToAccountManagement = () => print("account");

  MainMenuWidget({this.serverUrl});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.jpg"),
                    colorFilter:
                        ColorFilter.mode(Colors.blueGrey, BlendMode.lighten),
                    fit: BoxFit.cover),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                child: Title(
                    color: Colors.black,
                    child: Text(
                      "Welcome to ShoppingM8!",
                      style: TextStyle(fontSize: 42),
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
                      onPressed: moveToListScreen,
                      color: Colors.greenAccent,
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
        builder: (context) => LoginWidget(serverUrl: serverUrl)
    ));
  }
}
