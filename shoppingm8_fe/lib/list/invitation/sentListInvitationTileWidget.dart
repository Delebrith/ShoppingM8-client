import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shoppingm8_fe/common/roundButtonWidget.dart';
import 'package:shoppingm8_fe/list/invitation/sentListInvitationInfoWidget.dart';

import 'dto/listInvitationDto.dart';
import 'listInvitationApiProvider.dart';

class SentInvitationWidget extends StatefulWidget {
  final ListInvitationDto invitationDto;
  final ListInvitationApiProvider apiProvider;

  const SentInvitationWidget({Key key, this.invitationDto, this.apiProvider}) : super(key: key);

  @override
  _SentInvitationWidgetState createState() => _SentInvitationWidgetState(invitationDto: invitationDto, apiProvider: apiProvider);

}

class _SentInvitationWidgetState extends State<SentInvitationWidget> {
  final ListInvitationDto invitationDto;
  final ListInvitationApiProvider apiProvider;

  bool visible = true;

  _SentInvitationWidgetState({this.invitationDto, this.apiProvider});

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
            children: <Widget>[
              SentListInvitationInfoWidget(invitationDto: invitationDto),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RoundButtonWidget(
                    color: Colors.orange,
                    icon: Icons.arrow_back,
                    radius: 30,
                    onPressed: _withdrawInvitation,
                  ),
                  Text("Withraw")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  _withdrawInvitation() async {
    Response response = await apiProvider.withdrawInvitation(invitationDto.id);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        visible = false;
      });
    }
  }
}
