import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shoppingm8_fe/list/invitation/dto/listInvitationDto.dart';
import 'package:shoppingm8_fe/user/dto/userDto.dart';

import '../../main.dart';

class SentListInvitationInfoWidget extends StatefulWidget {
  final ListInvitationDto invitationDto;

  const SentListInvitationInfoWidget({Key key, this.invitationDto}) : super(key: key);

  @override
  _SentListInvitationInfoState createState() => _SentListInvitationInfoState(invitationDto: invitationDto);
}

class _SentListInvitationInfoState extends State<SentListInvitationInfoWidget> {
  final ListInvitationDto invitationDto;

  String _token;
  ImageProvider _defaultImage = AssetImage("assets/user.jpg");
  ImageProvider _invitedProfilePicture;

  _SentListInvitationInfoState({this.invitationDto}) {
    _setTokenAndProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text("List: ",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                Text(invitationDto.list.name,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 22),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text("Invited user: ",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10, top: 5),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 22,
                    backgroundImage: _invitedProfilePicture ?? _defaultImage,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(invitationDto.invited.name,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 22),
                  ),
                )
              ]
            )
          ]
      ),
    );
  }

  Future<void> _setTokenAndProfilePicture() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    _token = await storage.read(key: "JWT_access_token");
    if (invitationDto.invited.profilePicture != null) {
      setState(() {
        _invitedProfilePicture = _getProfilePicture(invitationDto.invited);
      });
    }

  }

  NetworkImage _getProfilePicture(userDto) {
    return NetworkImage(serverUrl + userDto.profilePicture, headers: {"Authorization": "Bearer " + _token});
  }
}