import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingm8_fe/list/dto/listResponseDto.dart';
import 'package:shoppingm8_fe/list/userToInviteTile.dart';
import 'package:shoppingm8_fe/user/dto/userDto.dart';
import 'package:shoppingm8_fe/user/userApiProvider.dart';

class AddUsersToListWidget extends StatefulWidget {
  final ListResponseDto listDto;

  const AddUsersToListWidget({Key key, this.listDto}) : super(key: key);

  @override
  _AddUsersTopListWidget createState() => _AddUsersTopListWidget(listDto);
}

class _AddUsersTopListWidget extends State<AddUsersToListWidget> {
  final key = new GlobalKey<_AddUsersTopListWidget>();
  final ListResponseDto listDto;

  final TextEditingController _searchQuery = new TextEditingController();
  final UserApiProvider _userApiProvider = UserApiProvider();
  List<Widget> usersToInvite = [];

  Widget noUsers = Container(
    width: double.infinity,
    height: double.infinity,
    alignment: Alignment.center,
    child: Text("No users."),
  );

  _AddUsersTopListWidget(this.listDto) {
    _searchQuery.addListener(() => _getUsers());
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Invite users to list"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            child: usersToInvite.isEmpty
                ? noUsers
                : ListView(padding: EdgeInsets.only(top: 50), scrollDirection: Axis.vertical, children: usersToInvite,),
          ),
          Container(
            height: double.infinity,
            alignment: Alignment.topCenter,
            child: TextField(
              controller: _searchQuery,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintText: "Search users...",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  _getUsers() async {
    Response response =
        await _userApiProvider.getUsers(20, 0, _searchQuery.text ?? "");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        usersToInvite.clear();
      });
      Map responseBody = response.data;
      List content = responseBody['content'];
      List<UserDto> dtos = content.map((dto) => UserDto.fromJson(dto)).toList();
      setState(() {
        usersToInvite = dtos
            .map((dto) => UserToInviteTileWidget(userDto: dto, listDto: listDto,))
            .cast<Widget>()
            .toList();
      });
    }
  }
}
