import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:shoppingm8_fe/auth/authenticationApiProvider.dart';
import 'package:shoppingm8_fe/common/customPopupMenuItem.dart';
import 'package:shoppingm8_fe/common/roundButtonWidget.dart';
import 'package:shoppingm8_fe/list/dto/listResponseDto.dart';
import 'package:shoppingm8_fe/list/listApiProvider.dart';
import 'package:shoppingm8_fe/list/listEditionDialog.dart';
import 'package:shoppingm8_fe/list/product/dto/productResponseDto.dart';
import 'package:shoppingm8_fe/list/product/productWidget.dart';
import 'package:shoppingm8_fe/user/dto/userDto.dart';

import 'addUsersToListWidget.dart';
import 'product/productApiProvider.dart';
import 'product/productCreationDialog.dart';

class ProductsListWidget extends StatefulWidget {
  final ListResponseDto listDto;

  const ProductsListWidget({Key key, this.listDto}) : super(key: key);

  @override
  _ProductsListWidgetState createState() => _ProductsListWidgetState(listDto: listDto);

}

class _ProductsListWidgetState extends State<StatefulWidget> {
  ListResponseDto listDto;

  ProductApiProvider _apiProvider;

  UserDto me;
  AuthenticationApiProvider _authenticationApiProvider = AuthenticationApiProvider();
  ListApiProvider _listApiProvider = ListApiProvider();

  Widget noProducts = Container(
    width: double.infinity,
    height: double.infinity,
    alignment: Alignment.center,
    child: Text("No products found."),
  );

  List<Widget> productList = [];

  _ProductsListWidgetState({this.listDto}) {
    _apiProvider = ProductApiProvider(id: listDto.id);
    _getProducts();
    _getMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listDto.name),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (x) => x(),
            itemBuilder: (BuildContext context) => [
              CustomPopupMenuItem(
                color: Colors.lightGreen,
                title: "Edit list",
                value: () => _editList(listDto, context),
                iconData: Icons.edit
              ),
              CustomPopupMenuItem(
                color: Colors.blue,
                title: "Invite users...",
                iconData: Icons.group_add,
                value: () => _inviteNewUsersToList(listDto, context),
//                value: () => print("x"),
              ),
              CustomPopupMenuItem(
                color: Colors.lightBlueAccent,
                title: "Go to shopping mode",
                iconData: Icons.add_shopping_cart,
                value: () => print("shopping mode"),
              ),
              (listDto.owner.id == me.id ?
              CustomPopupMenuItem(
                value: () => _deleteList(listDto, context),
                color: Colors.red,
                iconData: Icons.delete_forever,
                title: "Delete list",
              ) : CustomPopupMenuItem(
                value: () => _leaveList(listDto, context),
                color: Colors.orange,
                iconData: FontAwesome.logout,
                title: "Leave list",
              )),
            ]
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            child: productList.isEmpty ?
            noProducts :
            ListView(
              scrollDirection: Axis.vertical,
              children: productList,
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
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ProductCreationDialog(
                                title: "Create new product",
                                apiProvider: _apiProvider,
                                onSuccess: ((dto) => _addProduct(dto)),
                              );
                            });
                      },
                      color: Colors.greenAccent,
                      icon: Icons.add),
                ],
              )
          )
        ],
      ),
    );
  }

  void _getProducts() async {
    Response response = await _apiProvider.getListsProducts();
    if (response.statusCode == 200) {
      setState(() {
        List responseBody = response.data;
        print(responseBody);
        List<ProductResponseDto> dtos = responseBody.map((dto) =>
            ProductResponseDto.fromJson(dto)).toList();
        if (dtos.isNotEmpty) {
          productList = dtos.map((dto) =>
              ProductWidget(productDto: dto,
                    apiProvider: _apiProvider)
              ).toList();
        }
      });
    }
  }

  void _addProduct(ProductResponseDto dto) {
    setState(() {
      productList = productList + <ProductWidget>[ProductWidget(productDto: dto, apiProvider: _apiProvider,)];
    });
  }

  Future<void> _getMe() async {
    Response response = await _authenticationApiProvider.me();
    setState(() {
      me = UserDto.fromJson(response.data);
    });
  }

  _editList(ListResponseDto listDto, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ListEditionDialog(title: "Edit list", listDto: listDto, onSuccess: (dto) => _updateList(dto),);
        });
  }

  _updateList(ListResponseDto dto) {
    setState(() {
      listDto = dto;
    });
  }

  _deleteList(ListResponseDto listDto, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure, you want to delete the list?"),
          actions: <Widget>[
            FlatButton(
              color: Colors.deepOrangeAccent,
              child: Text("Yes"),
              onPressed: () => _requestDeletingList(context),
            ),
            FlatButton(
              color: Colors.transparent,
              child: Text("No", style: TextStyle(color: Colors.deepOrange),),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      }
    );
  }

  _leaveList(ListResponseDto listDto, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure, you want to leave the list?"),
            actions: <Widget>[
              FlatButton(
                color: Colors.deepOrangeAccent,
                child: Text("Yes"),
                onPressed: () => _requestLeavingList(context),
              ),
              FlatButton(
                color: Colors.transparent,
                child: Text("No", style: TextStyle(color: Colors.deepOrange),),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        }
    );
  }

  Future<void> _requestDeletingList(BuildContext context) async {
    Response response = await _listApiProvider.deleteList(listDto.id);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
    Navigator.pop(context);
  }

  _requestLeavingList(BuildContext context) async {
    Response response = await _listApiProvider.leaveList(listDto.id);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
    Navigator.pop(context);
  }

  _inviteNewUsersToList(ListResponseDto listDto, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => AddUsersToListWidget(listDto: listDto,)));
  }
}