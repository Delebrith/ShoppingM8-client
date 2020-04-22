import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingm8_fe/common/roundButtonWidget.dart';
import 'package:shoppingm8_fe/list/listApiProvider.dart';
import 'package:shoppingm8_fe/list/listCreationDialog.dart';

import 'ListTileWidget.dart';
import 'dto/listResponseDto.dart';
import 'listCreationDialog.dart';

class MyListsWidget extends StatefulWidget {
  final Dio dio;
  final String serverUrl;

  const MyListsWidget({Key key, this.dio, this.serverUrl}) : super(key: key);

  @override
  _MyListsWidgetState createState() => _MyListsWidgetState(dio: dio, serverUrl: serverUrl);

}

class _MyListsWidgetState extends State<StatefulWidget> {
  final Dio dio;
  final String serverUrl;

  ListApiProvider _apiProvider;
  List<Widget> lists = [
    Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Text("No lists found."),
    )];

  _MyListsWidgetState({this.dio, this.serverUrl}) {
    _apiProvider = ListApiProvider(dio: dio, serverUrl: serverUrl);
    _getLists();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            child: PageView(
              scrollDirection: Axis.horizontal,
              children: lists,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            height: double.infinity,
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RoundButtonWidget(
                    onPressed: () {
                      print("Invitations");
                    },
                    color: Colors.greenAccent,
                    icon: Icons.group_add),
                RoundButtonWidget(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ListCreationDialog(title: "Create new list", apiProvider: _apiProvider, onSuccess: _getLists,);
                          });
                    },
                    color: Colors.lightGreen,
                    icon: Icons.add),
              ],
            )
          )
        ],
      ),
    );
  }

  void _getLists() async {
    Response response = await _apiProvider.getMyLists();
    if (response.statusCode == 200) {
      setState(() {
        List responseBody = response.data;
        print(responseBody);
        List<ListResponseDto> dtos = responseBody.map((dto) => ListResponseDto.fromJson(dto)).toList();
        if (dtos.isNotEmpty)
          lists = dtos.map((dto) => ListTileWidget(listDto: dto,)).toList();
      });
    }
  }
}