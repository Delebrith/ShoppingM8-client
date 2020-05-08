import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppingm8_fe/common/roundButtonWidget.dart';
import 'package:shoppingm8_fe/list/dto/listResponseDto.dart';
import 'package:shoppingm8_fe/list/listApiProvider.dart';
import 'package:shoppingm8_fe/user/dto/userDto.dart';

import '../main.dart';
import 'invitation/dto/ListInvitationRequestDto.dart';

class UserToInviteTileWidget extends StatefulWidget {
  final UserDto userDto;
  final ListResponseDto listDto;

  const UserToInviteTileWidget({Key key, this.userDto, this.listDto}) : super(key: key);

  @override
  _UserToInviteWidgetState createState() => _UserToInviteWidgetState(userDto: userDto, listDto: listDto);

}

class _UserToInviteWidgetState extends State<UserToInviteTileWidget> {
  final UserDto userDto;
  final ListResponseDto listDto;

  String _token;
  ImageProvider _defaultImage = AssetImage("assets/user.jpg");
  ImageProvider _profilePicture;

  ListApiProvider _listApiProvider = ListApiProvider();
  Function inviteUserFunction;
  bool invited = false;
  bool visible = true;

  _UserToInviteWidgetState({this.userDto, this.listDto}) {
    if (userIsNotOwner() && userIsNotMember()) {
      this.inviteUserFunction = _inviteUserToList;
    } else {
      this.visible = false;
    }
    _setTokenAndProfilePicture();
  }

  bool userIsNotMember() => listDto.members.where((member) => member.id == userDto.id).toList().isEmpty;

  bool userIsNotOwner() => listDto.owner.id != userDto.id;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: _profilePicture ?? _defaultImage,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(userDto.name),
                  )
                ],
              ),
              (invited ?
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("invited"),
              ) :
              Column(
                children: <Widget>[
                  RoundButtonWidget(
                    radius: 25,
                    color: Colors.lightBlue,
                    icon: Icons.add,
                    onPressed: inviteUserFunction,
                  ),
                  Text("Invite user")
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  _inviteUserToList() async {
    print(userDto.name);
    Response response = await _listApiProvider.inviteUser(
        listDto.id, ListInvitationRequestDto(userDto.id));
    if (response.statusCode >= 200 && response.statusCode < 300 || response.statusCode == 409) {
      print("invited");
      setState(() {
        invited = true;
      });
    } else {
      Fluttertoast.showToast(msg: "Could not invite user", backgroundColor: Colors.orangeAccent);
    }
  }

  Future<void> _setTokenAndProfilePicture() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    _token = await storage.read(key: "JWT_access_token");
    if (userDto.profilePicture != null) {
      setState(() {
        _profilePicture = _getProfilePicture(userDto);
      });
    }

  }

  NetworkImage _getProfilePicture(userDto) {
    return NetworkImage(serverUrl + userDto.profilePicture, headers: {"Authorization": "Bearer " + _token});
  }
}