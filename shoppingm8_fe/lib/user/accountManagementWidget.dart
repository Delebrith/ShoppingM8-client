import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shoppingm8_fe/auth/authenticationApiProvider.dart';
import 'package:shoppingm8_fe/auth/loginWidget.dart';
import 'package:shoppingm8_fe/user/userDto.dart';

class AccountManagementWidget extends StatefulWidget {
  final String serverUrl;
  final Dio dio;
  
  AccountManagementWidget({this.serverUrl, this.dio});

  @override
  _AccountManagementWidgetState createState() => _AccountManagementWidgetState(dio: dio, serverUrl: serverUrl);
}

class _AccountManagementWidgetState extends State<StatefulWidget> {
  final Dio dio;
  final String serverUrl;

  UserDto _userDto;
  ImageProvider _image = AssetImage('assets/user.jpg');

  AuthenticationApiProvider _apiProvider;
  _AccountManagementWidgetState({this.dio, this.serverUrl}) {
    _apiProvider = AuthenticationApiProvider(serverUrl);
    _showUser();
  }

  Future<UserDto> _showUser() async {
    Response response = await _apiProvider.me(dio);
    if (response.statusCode == 200) {
      setState(() {
        _userDto = UserDto.fromJson(response.data);
      });
      if (_userDto.profilePicture != null) {
        String token = await FlutterSecureStorage().read(key: '');
        setState(() {
          _image = NetworkImage(serverUrl + _userDto.profilePicture,
            headers: {"Authorization": "Bearer " + token});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.jpg"),
                    fit: BoxFit.cover
                ),
              ),
            ),
            Center(
              child: Card(
                child: FractionallySizedBox(
                  heightFactor: 0.8,
                  widthFactor: 0.8,
                  child: Column(
                
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Title(
                        color: Colors.black,
                        child: Text(
                            "Your account:",
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                        )
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Image(
                            image: _image,
                            width: 100,
                            height: 100,
                        )
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Text(
                          "Displayed name: ${_userDto?.name}"
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: FlatButton(
                          child: Text("Delete account"),
                          color: Colors.red,
                          onPressed: _onDeleteAccount
                        )
                      ),
                    ]
                  )
                )
              )
            )
          ]
        );
  }

  void _confirmAccountDelete(BuildContext context, Function confirmationCallback) {
    // Based on https://stackoverflow.com/a/53844053/7108762
    AlertDialog alert = AlertDialog(
      title: Text("Removing account"),
      content: Text("Are you sure?"),
      actions: [
        FlatButton(
          child: Text("No"),
          onPressed:  Navigator.of(context).pop,
        ),
        FlatButton(
          child: Text("Yes"),
          onPressed:  () {
            Navigator.of(context).pop();
            confirmationCallback();
          },
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _onDeleteAccount() {
    _confirmAccountDelete(context, _deleteAccount);
  }

  Future<void> _deleteAccount() async {
    Response response = await _apiProvider.deleteAccount(dio);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var storage = FlutterSecureStorage();
      await storage.delete(key: "JWT_access_token");
      await storage.delete(key: "JWT_refresh_token");
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => LoginWidget(serverUrl: serverUrl)
      ));
    }
  }
}