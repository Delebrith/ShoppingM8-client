import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppingm8_fe/auth/authenticationApiProvider.dart';
import 'package:shoppingm8_fe/common/dto/errorDto.dart';
import 'package:shoppingm8_fe/common/roundButtonWidget.dart';
import 'package:shoppingm8_fe/list/dto/listResponseDto.dart';
import 'package:shoppingm8_fe/list/invitation/dto/listInvitationDto.dart';
import 'package:shoppingm8_fe/list/invitation/listInvitationApiProvider.dart';
import 'package:shoppingm8_fe/user/dto/userDto.dart';

import 'listInvitationInfoWidget.dart';

class ReceivedInvitationWidget extends StatefulWidget {
  final ListInvitationDto invitationDto;
  final ListInvitationApiProvider apiProvider;
  final Function addToListsFunction;

  const ReceivedInvitationWidget({Key key, this.invitationDto, this.apiProvider, this.addToListsFunction}) : super(key: key);

  @override
  _ReceivedInvitationWidget createState() => _ReceivedInvitationWidget(invitationDto: invitationDto, apiProvider: apiProvider, addToListsFunction: addToListsFunction);
}

class _ReceivedInvitationWidget extends State<ReceivedInvitationWidget> {
  final ListInvitationDto invitationDto;
  final ListInvitationApiProvider apiProvider;
  final Function addToListsFunction;
  bool visible = true;

  _ReceivedInvitationWidget({this.invitationDto, this.apiProvider, this.addToListsFunction});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ListInvitationInfoWidget(invitationDto: invitationDto),
              Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RoundButtonWidget(
                        color: Colors.lightGreen,
                        icon: FontAwesome.ok,
                        radius: 30,
                        onPressed: _acceptInvitation,
                      ),
                      Text("Accept")
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RoundButtonWidget(
                        color: Colors.red,
                        icon: FontAwesome.cancel,
                        radius: 30,
                        onPressed: _rejectInvitation,
                      ),
                      Text("Reject")
                    ],
                  )],
              )
            ],
          ),
        ),
      ),
    );
  }


  _acceptInvitation() async {
    Response response = await apiProvider.acceptInvitation(invitationDto.id);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        visible = false;
      });
      _refreshListsAfterAcceptance(invitationDto.list, invitationDto.invited);
    } else {
      ErrorDto error = ErrorDto.fromJson(response.data);
      Fluttertoast.showToast(msg: "Could not accept invitation. " + error.message, backgroundColor: Colors.orangeAccent);
    }
  }

  _rejectInvitation() async {
    Response response = await apiProvider.rejectInvitation(invitationDto.id);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        visible = false;
      });
    } else {
      ErrorDto error = ErrorDto.fromJson(response.data);
      Fluttertoast.showToast(msg: "Could not reject invitation. " + error.message, backgroundColor: Colors.orangeAccent);
    }
  }

  void _refreshListsAfterAcceptance(ListResponseDto list, UserDto invited) {
    list.members.add(invited);
    addToListsFunction(list);
  }
}