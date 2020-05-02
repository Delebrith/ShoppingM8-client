import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shoppingm8_fe/common/dto/errorDto.dart';
import 'package:shoppingm8_fe/list/product/productApiProvider.dart';
import 'package:shoppingm8_fe/list/product/productCategory.dart';

import 'dto/productResponseDto.dart';
import 'productEditionDialog.dart';

class ProductWidget extends StatelessWidget {
  final ProductResponseDto productDto;
  final ProductApiProvider apiProvider;
  final Function getProductsFunction;

  const ProductWidget({Key key, this.productDto, this.apiProvider, this.getProductsFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionExtentRatio: 0.25,
      child: Container(
        width: double.infinity,
//        height: 100,
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child:
                  CircleAvatar(
                      backgroundColor: ProductCategoryHepler.getColor(productDto.category),
                      radius: 30,
                      child: Icon(ProductCategoryHepler.getIcon(productDto.category), size: 30, color: Colors.white,)
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(productDto.name),
                            Text(productDto.purchasedAmount.toString() + "/" + productDto.requiredAmount.toString())
                          ],
                        ),
                        Text(ProductCategoryHepler.getName(productDto.category))
                      ],
                    ),
                  ),
                )
              ],
            )
        ),
      ),
      actionPane: SlidableBehindActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: "Edit",
          color: Colors.lightGreen,
          icon: Icons.edit,
          onTap: () => _editProduct(context),
        ),
        IconSlideAction(
          caption: "Delete",
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteProduct(context),
        )
      ],
    );
  }


  void _editProduct(context) {
    showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProductEditionDialog(productDto: productDto, title: "Edit product", apiProvider: apiProvider, onSuccess: getProductsFunction);
          });
  }

  Future<void> _deleteProduct(context) async {
    Response response = await apiProvider.deleteProduct(productDto.id);
    if (response.statusCode == 202) {
      final scaffold = Scaffold.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Product changes saved'),
          action: SnackBarAction(
              label: 'CLOSE', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
      getProductsFunction();
    } else {
      ErrorDto error = ErrorDto.fromJson(response.data);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Could not delete product"),
            content: Text(error.message),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: Navigator.of(context).pop,
              )
            ],
          )
      );
    }
  }
}