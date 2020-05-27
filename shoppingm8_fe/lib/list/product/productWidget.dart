import 'package:dio/dio.dart';
import 'package:eventhandler/eventhandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppingm8_fe/common/dto/errorDto.dart';
import 'package:shoppingm8_fe/common/roundButtonWidget.dart';
import 'package:shoppingm8_fe/list/product/productApiProvider.dart';
import 'package:shoppingm8_fe/list/product/productCategory.dart';
import 'package:shoppingm8_fe/list/shoppingMode.dart';

import 'dto/productResponseDto.dart';
import 'productEditionDialog.dart';

class ProductWidget extends StatefulWidget {
  final ProductResponseDto productDto;
  final ProductApiProvider apiProvider;

  final bool initialShoppingMode;

  const ProductWidget(
      {Key key, this.productDto, this.apiProvider, this.initialShoppingMode})
      : super(key: key);

  @override
  _ProductWidgetState createState() => _ProductWidgetState(
    productDto: productDto, apiProvider: apiProvider, shoppingMode: initialShoppingMode);
}

class _ProductWidgetState extends State<ProductWidget> {
  ProductResponseDto productDto;
  final ProductApiProvider apiProvider;
  final TextEditingController purchasedAmountController = TextEditingController();
  double purchasedAmount;

  bool visible = true;
  
  bool shoppingMode;

  _ProductWidgetState({this.productDto, this.apiProvider, this.shoppingMode}) {
    EventHandler().subscribe(_toggledShoppingMode);
    purchasedAmount = productDto.purchasedAmount;
    purchasedAmountController.text = purchasedAmount.toString();
  }

  @override
  @mustCallSuper
  dispose() {
    EventHandler().unsubscribe(_toggledShoppingMode);
    super.dispose();
  }

  _toggledShoppingMode(ShoppingModeToggleEvent event) {
    setState(() {
      this.shoppingMode = event.shoppingMode;
    });
  }

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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: shoppingMode ? 10 : 20),
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
                          padding: EdgeInsets.only(left: 15, right: shoppingMode ? 5 : 15),
                          child: Row (
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(productDto.name, style: TextStyle(fontSize: 18),),
                                  Text(ProductCategoryHepler.getName(
                                    productDto.category), style: TextStyle(color: Colors.grey))
                                ]
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: shoppingMode ? [
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 42,
                                          child: TextField(
                                            onChanged: _changeAmountText,
                                            enableInteractiveSelection: false,
                                            keyboardType: TextInputType.number,
                                            controller: purchasedAmountController,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(fontSize: 16, ))),
                                        Padding(
                                          padding: EdgeInsets.only(top: 6),
                                          child: Text("/ " +
                                            productDto.requiredAmount.toString() +
                                            " " + 
                                            productDto.unit,
                                            style: TextStyle(fontSize: 16))
                                        )
                                      ], 
                                    )
                                  ), 
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),  
                                        child: RoundButtonWidget(
                                          onPressed: _decreaseAmount,
                                          color: Colors.red,
                                          icon: Icons.remove,
                                          radius: 20,
                                        )
                                      ),
                                      RoundButtonWidget(
                                        onPressed: _increaseAmount,
                                        color: Colors.lightGreen,
                                        icon: Icons.add,
                                        radius: 20,
                                      ),
                                    ]
                                  )
                                ]: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 16),
                                    child: Text(purchasedAmount.toString() +
                                      "/" +
                                      productDto.requiredAmount.toString() +
                                      " " + 
                                      productDto.unit,
                                      style: TextStyle(fontSize: 16)),
                                  )
                                  
                                ]
                              ),
                            ],
                          )
                        ),
                      )
                    ],
                  )
              ),
            ),
            actionPane: SlidableBehindActionPane(),
            secondaryActions: shoppingMode ? [] : <Widget>[
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
      Fluttertoast.showToast(msg: "Product deleted");
    } else {
      ErrorDto error = ErrorDto.fromJson(response.data);
      Fluttertoast.showToast(msg: "Could not delete product. " + error.message, backgroundColor: Colors.orangeAccent);
    }
  }

  void _changeAmountText(String text) {
    double purchasedAmount = double.parse(text);
    bool outOfBounds = false;

    if (purchasedAmount < 0) {
      purchasedAmount = 0;
      outOfBounds = true;
    }
    if (purchasedAmount > productDto.requiredAmount) {
      purchasedAmount = productDto.requiredAmount;
      outOfBounds = true;
    }
    
    if (outOfBounds)
      _updatePurchasedAmountText();
    _changeAmount(purchasedAmount);
  }

  void _increaseAmount() {
    double purchasedAmount = this.purchasedAmount + 1;
    if (purchasedAmount > productDto.requiredAmount)
      purchasedAmount = productDto.requiredAmount;

    _changeAmount(purchasedAmount);
    _updatePurchasedAmountText();
  }

  void _decreaseAmount() {
    double purchasedAmount = this.purchasedAmount - 1;
    purchasedAmount -= 1;
    if (purchasedAmount < 0)
      purchasedAmount = 0;
    
    _changeAmount(purchasedAmount);
    _updatePurchasedAmountText();
  }

  void _changeAmount(double newValue) {
    if (this.purchasedAmount == newValue)
      return;
    
    apiProvider.purchaseProduct(productDto.id, newValue - this.purchasedAmount);

    this.purchasedAmount = newValue;
  }

  void _updatePurchasedAmountText() {
    int previousPosition = purchasedAmountController.selection.baseOffset;
    purchasedAmountController.text = purchasedAmount.toString();
    if (previousPosition != -1) {
      if(purchasedAmountController.text.length < previousPosition)
        previousPosition = purchasedAmountController.text.length;
      purchasedAmountController.selection = 
        TextSelection.fromPosition(
          TextPosition(
            offset: previousPosition
          )
        );
    }
  }
}
