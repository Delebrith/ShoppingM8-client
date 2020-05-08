import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shoppingm8_fe/list/invitation/dto/listInvitationDto.dart';
import 'package:shoppingm8_fe/user/dto/userDto.dart';

import '../../main.dart';

class ListInvitationInfoWidget extends StatefulWidget {
  final ListInvitationDto invitationDto;

  const ListInvitationInfoWidget({Key key, this.invitationDto}) : super(key: key);

  @override
  _ListInvitationInfoState createState() => _ListInvitationInfoState(invitationDto: invitationDto);
}

class _ListInvitationInfoState extends State<ListInvitationInfoWidget> {
  final ListInvitationDto invitationDto;

  String _token;
  ImageProvider _defaultImage = AssetImage("assets/user.jpg");
  ImageProvider _ownersProfilePicture;
  List<ImageProvider> membersProfilePictures = [NetworkImage("")];

  _ListInvitationInfoState({this.invitationDto}) {
    _setTokenAndProfilePictures();
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10, top: 5),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 22,
                  backgroundImage: _ownersProfilePicture ?? _defaultImage,
                ),
              )
            ] + membersProfilePictures.map((imageProvider) => Padding(
              padding: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 16,
                backgroundImage: imageProvider ?? _defaultImage,
              ),
            )).toList()
            + (invitationDto.list.members.isNotEmpty && invitationDto.list.members.length > 3 ? [Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text("...and more"),
            )] : []),
          )
        ]
      ),
    );
  }

  Future<void> _setTokenAndProfilePictures() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    _token = await storage.read(key: "JWT_access_token");
    if (invitationDto.list.owner.profilePicture != null) {
      setState(() {
        _ownersProfilePicture = _getProfilePicture(invitationDto.list.owner);
      });
    }

    if (invitationDto.list.members.isNotEmpty) {
      List<UserDto> displayedMembers = invitationDto.list.members.toList().length > 3 ?
      invitationDto.list.members.getRange(0, 3) :
      invitationDto.list.members;

      setState(() {
        membersProfilePictures = displayedMembers
            .map((dto) => dto.profilePicture == null ? null : _getProfilePicture(dto))
            .toList();
      });
    }
  }

  NetworkImage _getProfilePicture(userDto) {
    return NetworkImage(serverUrl + userDto.profilePicture, headers: {"Authorization": "Bearer " + _token});
  }
}