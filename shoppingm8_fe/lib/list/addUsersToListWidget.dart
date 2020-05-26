import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppingm8_fe/list/dto/listResponseDto.dart';
import 'package:shoppingm8_fe/list/userToInviteTile.dart';
import 'package:shoppingm8_fe/user/dto/userDto.dart';
import 'package:shoppingm8_fe/user/userApiProvider.dart';

class AddUsersToListWidget extends StatefulWidget {
  final ListResponseDto listDto;

  const AddUsersToListWidget({Key key, this.listDto}) : super(key: key);

  @override
  _AddUsersToListWidgetState createState() => _AddUsersToListWidgetState(listDto);
}

class _AddUsersToListWidgetState extends State<AddUsersToListWidget> {
  final key = new GlobalKey<_AddUsersToListWidgetState>();
  final ListResponseDto listDto;

  final TextEditingController _searchQuery = TextEditingController();
  final StreamController _streamController = StreamController();
  final ScrollController _listViewController = ScrollController();
  final UserApiProvider _userApiProvider = UserApiProvider();

  Widget noUsers = Container(
    width: double.infinity,
    height: double.infinity,
    alignment: Alignment.center,
    child: Text("No users."),
  );

  List<UserDto> _users = [];
  int _currentPage = 0;
  int _totalPages = 0;

  _AddUsersToListWidgetState(this.listDto) {
    _searchQuery.addListener(() => _getUsers());
    _listViewController.addListener(_endOfListListener);
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
            child: StreamBuilder(
                    stream: _streamController.stream,
                    initialData: [],
                    builder: (BuildContext buildContext, AsyncSnapshot<dynamic> users) {
                      if (users == null || users.data == null) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text("Loading..."),
                            )
                          ],
                        );
                      }
                      if (users.data.isEmpty) {
                        return noUsers;
                      }
                      return ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return UserToInviteTileWidget(listDto: listDto, userDto: users.data[index],);
                          },
                          itemCount: users.data.length,
                          padding: EdgeInsets.only(top: 50),
                          controller: _listViewController,
                      );
                    },
                  )
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
    _streamController.sink.add(null);
    _currentPage = 0;
    Response response =
        await _userApiProvider.getUsers(20, 0, _searchQuery.text ?? "");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Map responseBody = response.data;
      List<UserDto> searchResult = _getSearchResult(responseBody);
      _streamController.add(searchResult);
      setState(() {
        _totalPages = responseBody['totalPages'];
        _users = searchResult;
      });
    } else {
      Fluttertoast.showToast(msg: "Could not download users.", backgroundColor: Colors.orangeAccent);
    }
  }

  List<UserDto> _getSearchResult(Map responseBody) {
    List content = responseBody['content'];
    List<UserDto> searchResult = content.map((dto) => UserDto.fromJson(dto)).toList();
    searchResult.removeWhere((dto) => listDto.owner.id == dto.id);
    listDto.members
        .forEach((member) => searchResult.removeWhere((dto) => member.id == dto.id));
    return searchResult;
  }

  Future<void> _endOfListListener() async {
    if (_currentPage < _totalPages - 1
        && _listViewController.offset >= _listViewController.position.maxScrollExtent) {
      _currentPage = _currentPage + 1;
      Response response =
          await _userApiProvider.getUsers(20, _currentPage, _searchQuery.text ?? "");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map responseBody = response.data;
        List<UserDto> searchResult = _getSearchResult(responseBody);
        setState(() {
          _users.addAll(searchResult);
        });
        _streamController.add(_users);
      } else {
        Fluttertoast.showToast(msg: "Could not download users.", backgroundColor: Colors.orangeAccent);
      }
    }
  }
}
