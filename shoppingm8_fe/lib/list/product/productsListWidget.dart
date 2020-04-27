import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingm8_fe/common/roundButtonWidget.dart';
import 'package:shoppingm8_fe/list/product/dto/productResponseDto.dart';
import 'package:shoppingm8_fe/list/product/productCategory.dart';
import 'package:shoppingm8_fe/list/product/productWidget.dart';

import 'productApiProvider.dart';
import 'productCreationDialog.dart';

class ProductsListWidget extends StatefulWidget {
  final Dio dio;
  final String serverUrl;
  final num id;
  final String name;

  const ProductsListWidget({Key key, this.dio, this.serverUrl, this.id, this.name}) : super(key: key);

  @override
  _ProductsListWidgetState createState() => _ProductsListWidgetState(dio: dio, serverUrl: serverUrl, id: id, name: name);

}

class _ProductsListWidgetState extends State<StatefulWidget> {
  final Dio dio;
  final String serverUrl;
  final num id;
  final String name;

  ProductApiProvider _apiProvider;
  Widget productList = Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Text("No products found."),
    );

  _ProductsListWidgetState({this.name, this.id, this.dio, this.serverUrl}) {
    _apiProvider = ProductApiProvider(dio: dio, serverUrl: serverUrl, id: id);
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            child: productList,
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
                        print("Shopping mode");
                      },
                      color: Colors.lightBlueAccent,
                      icon: Icons.add_shopping_cart),
                  RoundButtonWidget(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ProductCreationDialog(title: "Create new product", apiProvider: _apiProvider, onSuccess: _getProducts,);
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
          List<Widget> products = dtos.map((dto) =>
              Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ProductWidget(productDto: dto,
                    apiProvider: _apiProvider,
                    getProductsFunction: _getProducts,)
              )).toList();
          productList = ListView(
            scrollDirection: Axis.vertical,
            children: products,
          );
        }
      });
    }
  }
}