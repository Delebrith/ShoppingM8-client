import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingm8_fe/list/receipt/receiptDto.dart';
import 'package:shoppingm8_fe/main.dart';
import 'package:shoppingm8_fe/user/userLabelWidget.dart';

class ReceiptWidget extends StatelessWidget {
  final ReceiptDto receiptDto;
  final String token;

  const ReceiptWidget({Key key, this.receiptDto, this.token}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: UserLabelWidget(
              userDto: receiptDto.createdBy,
              fontSize: 18,
              avatarRadius: 28,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Image(
              image: NetworkImage(serverUrl + receiptDto.url, headers: {"Authorization": "Bearer " + token}),
            ),
          )
        ],
      ),
    );
  }

}