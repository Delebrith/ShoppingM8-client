import 'package:dio/dio.dart';
import 'package:eventhandler/eventhandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppingm8_fe/auth/authenticationApiProvider.dart';
import 'package:shoppingm8_fe/common/customPopupMenuItem.dart';
import 'package:shoppingm8_fe/common/roundButtonWidget.dart';
import 'package:shoppingm8_fe/list/dto/listResponseDto.dart';
import 'package:shoppingm8_fe/list/listApiProvider.dart';
import 'package:shoppingm8_fe/list/listEditionDialog.dart';
import 'package:shoppingm8_fe/list/product/dto/productResponseDto.dart';
import 'package:shoppingm8_fe/list/product/productWidget.dart';
import 'package:shoppingm8_fe/list/receipt/receiptListWidget.dart';
import 'package:shoppingm8_fe/list/shoppingMode.dart';
import 'package:shoppingm8_fe/maps/mapWidget.dart';
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

  bool shoppingMode = false;

  Widget noProducts = Container(
    width: double.infinity,
    height: double.infinity,
    alignment: Alignment.center,
    child: Text("No products found."),
  );

  List<ProductWidget> productList = [];

  _ProductsListWidgetState({this.listDto}) {
    _apiProvider = ProductApiProvider(id: listDto.id);
    _getProducts();
    _getMe();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(listDto.name),
          actions: shoppingMode ? null : <Widget>[
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
                  color: Colors.greenAccent,
                  title: "Find shops on map",
                  iconData: Icons.map,
                  value: () => _findShops(listDto, context),
                ),
                CustomPopupMenuItem(
                  color: Colors.blue,
                  title: "Invite users...",
                  iconData: Icons.group_add,
                  value: () => _inviteNewUsersToList(listDto, context),
                ),
                CustomPopupMenuItem(
                  color: Colors.lightBlueAccent,
                  title: shoppingMode ? "End shopping mode" : "Go to shopping mode",
                  iconData: Icons.add_shopping_cart,
                  value: () => _toggleShoppingMode(),
                ),
                CustomPopupMenuItem(
                  color: Colors.deepPurpleAccent,
                  title: "See receipts",
                  iconData: Icons.receipt,
                  value: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiptListWidget(listDto: listDto))),
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
                    shoppingMode ?
                    RoundButtonWidget(
                        onPressed: _toggleShoppingMode,
                        color: Colors.lightGreen,
                        icon: Icons.remove_shopping_cart) :
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
      )
    );
  }

  Future<bool> _onWillPop() {
    if (shoppingMode) {
      _toggleShoppingMode();
      return Future.value(false);
    }
    return Future.value(true);
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
                    apiProvider: _apiProvider,
                    initialShoppingMode: shoppingMode,)
              ).toList();
        }
      });
    } else {
      Fluttertoast.showToast(msg: "Could not download products.", backgroundColor: Colors.orangeAccent);
    }
  }

  void _addProduct(ProductResponseDto dto) {
    setState(() {
      productList = productList + <ProductWidget>[ProductWidget(productDto: dto, apiProvider: _apiProvider, initialShoppingMode: shoppingMode,)];
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

  void _toggleShoppingMode() {
    setState(() {
      shoppingMode = !shoppingMode;
      EventHandler().send(ShoppingModeToggleEvent(shoppingMode));
    });

  }

  Future<void> _requestDeletingList(BuildContext context) async {
    Response response = await _listApiProvider.deleteList(listDto.id);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Navigator.pop(context);
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "List deleted");
    } else {
      Fluttertoast.showToast(msg: "Could not delete list.", backgroundColor: Colors.orangeAccent);
    }
    Navigator.pop(context);
  }

  _requestLeavingList(BuildContext context) async {
    Response response = await _listApiProvider.leaveList(listDto.id);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Navigator.pop(context);
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "You left list.");
    } else {
      Fluttertoast.showToast(msg: "Could not leave list.", backgroundColor: Colors.orangeAccent);
    }
    Navigator.pop(context);
  }

  _inviteNewUsersToList(ListResponseDto listDto, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => AddUsersToListWidget(listDto: listDto,)));
  }

  _findShops(ListResponseDto listDto, BuildContext context) async {
    Response productsResponse = await _apiProvider.getListsProducts();
    if (productsResponse.statusCode >= 200 && productsResponse.statusCode < 300) {
      List responseBody = productsResponse.data;
      List<ProductResponseDto> dtos = responseBody.map((dto) =>
          ProductResponseDto.fromJson(dto)).toList();
      Navigator.push(context, MaterialPageRoute(builder: (context) => MapWidget(
          categories: dtos.map((e) => e.category).toSet())));
    }
  }
}