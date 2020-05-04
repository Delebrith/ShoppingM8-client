import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppingm8_fe/common/roundButtonWidget.dart';
import 'package:shoppingm8_fe/list/invitationsTileWidget.dart';
import 'package:shoppingm8_fe/list/listApiProvider.dart';
import 'package:shoppingm8_fe/list/listCreationDialog.dart';
import 'package:shoppingm8_fe/list/productsListWidget.dart';

import 'ListTileWidget.dart';
import 'dto/listResponseDto.dart';
import 'listCreationDialog.dart';

class MyListsWidget extends StatefulWidget {
  @override
  _MyListsWidgetState createState() => _MyListsWidgetState();

}

class _MyListsWidgetState extends State<StatefulWidget> {
  ListApiProvider _apiProvider = ListApiProvider();
  List<Widget> lists = [
    InvitationsTileWidget()
  ];

  _MyListsWidgetState() {
    _getLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My shopping lists"),
      ),
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
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            height: double.infinity,
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
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
          lists = dtos.map((dto) => ListTileWidget(listDto: dto, goToProductsListWidget: _goToProductsWidget(dto),)).cast<Widget>().toList();
          lists.add(InvitationsTileWidget());
      });
    } else {
      Fluttertoast.showToast(msg: "Could not download lists.", backgroundColor: Colors.orangeAccent);
    }
  }

  Function _goToProductsWidget(ListResponseDto dto) {
    return (context) => Navigator.push(context, MaterialPageRoute(
        builder: (context) => ProductsListWidget(listDto: dto,)));
  }
}