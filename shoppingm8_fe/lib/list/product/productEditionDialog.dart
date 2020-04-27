import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppingm8_fe/common/dto/errorDto.dart';
import 'package:shoppingm8_fe/list/product/dto/productResponseDto.dart';
import 'package:shoppingm8_fe/list/product/productCategory.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import 'dto/productRequestDto.dart';
import 'productApiProvider.dart';

class ProductEditionDialog extends StatefulWidget {
  final String title;
  final ProductApiProvider apiProvider;
  final Function onSuccess;
  final ProductResponseDto productDto;

  ProductEditionDialog({Key key, this.title, this.apiProvider, this.onSuccess, this.productDto}) : super(key: key);

  @override
  _ProductEditionWidgetState createState() => _ProductEditionWidgetState(title: this.title, apiProvider: this.apiProvider, onSuccess: this.onSuccess, productDto: this.productDto);

}

class _ProductEditionWidgetState extends State {
  final GlobalKey<FormState> _productForm = GlobalKey<FormState>();
  final String title;
  final ProductApiProvider apiProvider;
  final ProductResponseDto productDto;
  final Function onSuccess;

  String _name;
  num _requiredAmount;
  String _unit;
  ProductCategory _category;

  _ProductEditionWidgetState({this.productDto, this.title, this.apiProvider, this.onSuccess}) {
    _name = productDto.name;
    _requiredAmount = productDto.requiredAmount;
    _unit = productDto.unit;
    _category = productDto.category;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _productForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: true,
                      autocorrect: false,
                      decoration: InputDecoration(labelText: "Product name"),
                      initialValue: _name,
                      onSaved: (value) => _name = value,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      autocorrect: false,
                      initialValue: _requiredAmount.toString(),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(labelText: "Required amount"),
                      onSaved: (value) => _requiredAmount = num.parse(value),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      autocorrect: false,
                      initialValue: _unit,
                      decoration: InputDecoration(labelText: "Unit (kg, g, pc...)"),
                      onSaved: (value) => _unit = value,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: DropDownFormField(
                      dataSource: _getDropdownItems(),
                      titleText: "Product category",
                      textField: "display",
                      valueField: "value",
                      onSaved: (value) => _category = value,
                      onChanged: (value) => setState(() {
                        _category = value;
                      }),
                      value: _category,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        child: Text("Submit"),
                        onPressed: (() => _submit(context))
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Close"),
          onPressed: Navigator.of(context).pop,
        )
      ],
    );
  }

  Future<void> _submit(context) async {
    _productForm.currentState.save();
    ProductRequestDto dto = ProductRequestDto(name: _name, category: _category, requiredAmount: _requiredAmount, unit: _unit);
    Response response = await apiProvider.createProduct(dto);
    if (response.statusCode == 201) {
      Navigator.pop(context);
      final scaffold = Scaffold.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Product changes saved'),
          action: SnackBarAction(
              label: 'CLOSE', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
      onSuccess();
    } else {
      Navigator.pop(context);
      ErrorDto error = ErrorDto.fromJson(response.data);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Could not edit product"),
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

  List<Map<String, Object>> _getDropdownItems() {
    return ProductCategory.values
        .map((val) => {"display": ProductCategoryHepler.getName(val), "value": val})
        .toList();
  }

}