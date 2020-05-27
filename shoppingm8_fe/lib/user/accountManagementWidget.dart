import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shoppingm8_fe/main.dart';
import 'package:shoppingm8_fe/auth/authenticationApiProvider.dart';
import 'package:shoppingm8_fe/auth/dto/authenticatedUserDto.dart';
import 'package:shoppingm8_fe/auth/loginWidget.dart';

class AccountManagementWidget extends StatefulWidget {
  @override
  _AccountManagementWidgetState createState() => _AccountManagementWidgetState();
}

class _AccountManagementWidgetState extends State<StatefulWidget> {

  AuthenticatedUserDto _userDto;
  ImageProvider _image = AssetImage('assets/user.jpg');

  AuthenticationApiProvider _apiProvider;
  _AccountManagementWidgetState() {
    _apiProvider = AuthenticationApiProvider();
    _showUser();
  }

  Future<AuthenticatedUserDto> _showUser() async {
    Response response = await _apiProvider.me();
    if (response.statusCode == 200) {
      setState(() {
        _userDto = AuthenticatedUserDto.fromJson(response.data);
      });
      if (_userDto.profilePicture != null) {
        String token = await FlutterSecureStorage().read(key: 'JWT_access_token');
        setState(() {
          try {
            _image = NetworkImage(serverUrl + _userDto.profilePicture,
              headers: {"Authorization": "Bearer " + token});
          } catch(e) {

          }
        });
      }
    }
    return _userDto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Account"),
      ),
      body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.jpg"),
                    fit: BoxFit.cover
                )
              ),
            ),
            Center(
              child: Card(
                child: FractionallySizedBox(
                  heightFactor: 0.8,
                  widthFactor: 0.8,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: FadeInImage(
                              width: 100,
                              height: 100,
                              image: _image,
                              placeholder: AssetImage('assets/user.jpg'),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Column(
                            children:[
                              Text(
                                "${_userDto?.name}"
                              ),
                              Text(
                                "${_userDto?.email}"
                              )
                            ]
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20, top: 80),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: FlatButton(
                            child: Text("Delete account"),
                            textColor: Colors.red,
                            color: Colors.white,
                            onPressed: _onDeleteAccount
                          )
                        ),
                      ]
                    )
                  )
                )
              )
            )
          ]
        )
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
    Response response = await _apiProvider.deleteAccount();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var storage = FlutterSecureStorage();
      await storage.delete(key: "JWT_access_token");
      await storage.delete(key: "JWT_refresh_token");
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => LoginWidget()
      ));
    }
  }
}