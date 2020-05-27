import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppingm8_fe/common/roundButtonWidget.dart';
import 'package:shoppingm8_fe/list/dto/listResponseDto.dart';
import 'package:shoppingm8_fe/list/receipt/receiptApiProvider.dart';
import 'package:shoppingm8_fe/list/receipt/receiptDto.dart';
import 'package:shoppingm8_fe/list/receipt/receiptWidget.dart';

class ReceiptListWidget extends StatefulWidget {
  final ListResponseDto listDto;

  const ReceiptListWidget({Key key, this.listDto}) : super(key: key);

  @override
  _ReceiptListWidgetState createState() => _ReceiptListWidgetState(listDto: listDto);

}

class _ReceiptListWidgetState extends State<ReceiptListWidget> {
  final ListResponseDto listDto;
  ReceiptApiProvider _apiProvider;
  String _token;

  ScrollController _scrollController;
  List<Widget> receipts = [];

  Widget noReceipts = Container(
    width: double.infinity,
    height: double.infinity,
    alignment: Alignment.center,
    child: Text("No receipts found."),
  );


  _ReceiptListWidgetState({this.listDto}) {
    _scrollController = new ScrollController();
    _apiProvider = ReceiptApiProvider(id: listDto.id);
    _readToken();
    _getReceipts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipts of " + listDto.name),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            child: receipts.isEmpty ?
            noReceipts : ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) => receipts[index],
              itemCount: receipts.length,
              controller: _scrollController,
            )
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: double.infinity,
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RoundButtonWidget(
                      onPressed: _addReceipt,
                      color: Colors.lightBlue,
                      icon: Icons.camera_enhance),
                ],
              )
          )
        ],
      ),
    );
  }

  Future<void> _getReceipts() async {
    Response response = await _apiProvider.getListsReceipts();
    if (response.statusCode == 200) {
      setState(() {
        List responseBody = response.data;
        print(responseBody);
        List<ReceiptDto> dtos = responseBody.map((dto) =>
            ReceiptDto.fromJson(dto)).toList();
        if (dtos.isNotEmpty) {
          receipts = dtos.map((dto) =>
              ReceiptWidget(receiptDto: dto, token: _token,)
          ).toList();
        }
      });
    } else {
      Fluttertoast.showToast(msg: "Could not download receipts.", backgroundColor: Colors.orangeAccent);
    }
  }

  _addReceipt() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    Response response = await _apiProvider.createReceipt(image.path);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      ReceiptDto receiptDto = ReceiptDto.fromJson(response.data);
      setState(() {
        receipts.add(ReceiptWidget(receiptDto: receiptDto, token: _token,));
      });
    } else {
      Fluttertoast.showToast(msg: "Could not add new receipt.", backgroundColor: Colors.orangeAccent);
    }

    setState(() {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, curve: Curves.ease, duration: Duration(milliseconds: 300));
    });
  }

  Future<void> _readToken() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    _token = await storage.read(key: "JWT_access_token");
  }
}