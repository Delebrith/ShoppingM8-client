import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shoppingm8_fe/list/product/productApiProvider.dart';
import 'package:shoppingm8_fe/list/product/productCategory.dart';

import 'dto/productResponseDto.dart';

class ProductWidget extends StatelessWidget {
  final ProductResponseDto productDto;
  final ProductApiProvider apiProvider;

  const ProductWidget({Key key, this.productDto, this.apiProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionExtentRatio: 0.25,
      child: Container(
        width: double.infinity,
        height: 100,
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircleAvatar(
                    backgroundColor: ProductCategoryHepler.getColor(productDto.category),
                    radius: 25,
                    child: Icon(ProductCategoryHepler.getIcon(productDto.category))
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(productDto.name),
                          Text(productDto.purchasedAmount.toString() + "/" + productDto.requiredAmount.toString())
                        ],
                      ),
                      Text(ProductCategoryHepler.getName(productDto.category))
                    ],
                  ),
                )
              ],
            )
        ),
      ),
      actions: [

      ]
    );
  }

}