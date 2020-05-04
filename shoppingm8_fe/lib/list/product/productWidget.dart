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

class ProductWidget extends StatefulWidget {
  final ProductResponseDto productDto;
  final ProductApiProvider apiProvider;

  const ProductWidget(
      {Key key, this.productDto, this.apiProvider})
      : super(key: key);

  @override
  _ProductWidgetState createState() => _ProductWidgetState(productDto: productDto, apiProvider: apiProvider);
}

class _ProductWidgetState extends State<ProductWidget> {
  ProductResponseDto productDto;
  final ProductApiProvider apiProvider;

  bool visible = true;

  _ProductWidgetState({this.productDto, this.apiProvider});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Card(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Slidable(
            actionExtentRatio: 0.25,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: CircleAvatar(
                            backgroundColor: ProductCategoryHepler.getColor(
                                productDto.category),
                            radius: 30,
                            child: Icon(
                              ProductCategoryHepler.getIcon(productDto.category),
                              size: 30,
                              color: Colors.white,
                            )),
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
                                  Text(productDto.name, style: TextStyle(fontSize: 18),),
                                  Text(productDto.purchasedAmount.toString() +
                                      "/" +
                                      productDto.requiredAmount.toString(),
                                      style: TextStyle(fontSize: 16))
                                ],
                              ),
                              Text(ProductCategoryHepler.getName(
                                  productDto.category), style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
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
          )
      ),
    );
  }

  void _editProduct(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ProductEditionDialog(
              productDto: productDto,
              title: "Edit product",
              apiProvider: apiProvider,
              onSuccess: ((dto) => setState(() {
                this.productDto = dto;
              })));
        });
  }

  Future<void> _deleteProduct(context) async {
    Response response = await apiProvider.deleteProduct(productDto.id);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        visible = false;
      });
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
              ));
    }
  }
}
