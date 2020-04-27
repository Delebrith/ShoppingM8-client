import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingm8_fe/common/roundButtonWidget.dart';
import 'package:shoppingm8_fe/list/dto/listResponseDto.dart';
import 'package:shoppingm8_fe/user/userLabelWidget.dart';

class ListTileWidget extends StatelessWidget {
  final ListResponseDto listDto;
  final Function goToProductsListWidget;

  var _memberLabels = <Widget>[
    Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text("No other members."),
    ),
  ];

  ListTileWidget({Key key, this.listDto, this.goToProductsListWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 70, top: 30, left: 20, right: 20),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Title(
                          color: Colors.black,
                          child: Text(listDto.name,
                              style: TextStyle(
                                fontSize: 32,
                              )
                          ),
                        ),
                      ),
                    ),
                    RoundButtonWidget(
                      color: Colors.greenAccent,
                      icon: Icons.forward,
                      onPressed: () => goToProductsListWidget(context),
                      radius: 25,
                    ),
                  ],
                ),
              ),
              Row(
                  children: <Widget>[
                    Expanded(
                        child: Divider(
                          thickness: 2,
                        )
                    ),
                  ]
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Owned by:",
                        style: TextStyle(
                            fontSize: 26
                        )
                    ),
                    UserLabelWidget(
                      userDto: listDto.owner,
                      avatarRadius: 40,
                      fontSize: 24,
                    ),
                  ],
                ),
              ),
              Row(
                  children: <Widget>[
                    Expanded(
                        child: Divider(
                          thickness: 2,
                        )
                    ),
                  ]
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Other members:",
                            style: TextStyle(
                                fontSize: 26
                            )
                        )] + _memberLabels
                      ,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
