import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppingm8_fe/list/invitation/dto/listInvitationDto.dart';
import 'package:shoppingm8_fe/list/invitation/dto/myListInvitationsDto.dart';
import 'package:shoppingm8_fe/list/invitation/listInvitationApiProvider.dart';
import 'package:shoppingm8_fe/list/invitation/receivedListInvitationTileWidget.dart';
import 'package:shoppingm8_fe/list/invitation/sentListInvitationTileWidget.dart';

class ListInvitationsWidget extends StatefulWidget {
  final Function addToListsFunction;

  const ListInvitationsWidget({Key key, this.addToListsFunction}) : super(key: key);

  @override
  _ListInvitationsWidgetState createState() => _ListInvitationsWidgetState(addToListFunction: addToListsFunction);
}

class _ListInvitationsWidgetState extends State<ListInvitationsWidget> {
  final Function addToListFunction;
  ListInvitationApiProvider _apiProvider = ListInvitationApiProvider();

  _ListInvitationsWidgetState({this.addToListFunction}) {
    _getInvitations();
  }

  Widget noInvitationReceived = Container(
    padding: EdgeInsets.all(70),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [Text("No invitations received.")],
    ),
  );

  Widget noSentInvitations = Container(
    padding: EdgeInsets.all(70),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [Text("No pending invitations.")],
    ),
  );

  List<Widget> sentInvitationList = [];
  List<Widget> receivedInvitationList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("My invitations to lists"),
      ),
      body: Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(children: <Widget>[
                Expanded(child: Divider()),
                Text("Received invitations", style: TextStyle(fontSize: 14, color: Colors.grey),),
                Expanded(child: Divider()),
              ]),
            )
          ] +
              (receivedInvitationList.isNotEmpty ? [Column(children: receivedInvitationList)] : [noInvitationReceived])  +
          [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(children: <Widget>[
                Expanded(child: Divider()),
                Text("Sent invitations (pending)", style: TextStyle(fontSize: 14, color: Colors.grey),),
                Expanded(child: Divider()),
              ]),
            )
          ]
         + (sentInvitationList.isNotEmpty ? [Column(children: sentInvitationList)] : [noSentInvitations]) ,
        ),
      )
    );
  }

  void _getInvitations() async {
    Response response = await _apiProvider.getMyInvitations();
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        MyListInvitationsDto responseBody = MyListInvitationsDto.fromJson(response.data);

        List<ListInvitationDto> received = responseBody.received;
        if (received.isNotEmpty) {
          _processReceivedInvitationsIntoWidgets(received);
        }

        List<ListInvitationDto> sent = responseBody.sent;
        if (sent.isNotEmpty) {
          _processSentInvitationsIntoWidgets(sent);
        }
      });
    } else {
      Fluttertoast.showToast(msg: "Could not download invitations.", backgroundColor: Colors.orangeAccent);
    }
  }

  void _processSentInvitationsIntoWidgets(List<ListInvitationDto> sent) {
    List<Widget> invitations = sent
        .map((dto) => SentInvitationWidget(
          invitationDto: dto,
          apiProvider: _apiProvider,
        ))
        .toList();
    sentInvitationList = invitations;
  }

  void _processReceivedInvitationsIntoWidgets(List<ListInvitationDto> received) {
    List<Widget> invitations = received
        .map((dto) => ReceivedInvitationWidget(
              invitationDto: dto,
              apiProvider: _apiProvider,
              addToListsFunction: addToListFunction,
            ))
        .toList();
    receivedInvitationList = invitations;
  }
}
