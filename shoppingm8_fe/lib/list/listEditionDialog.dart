import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingm8_fe/common/dto/errorDto.dart';
import 'package:shoppingm8_fe/list/dto/listRequestDto.dart';
import 'package:shoppingm8_fe/list/dto/listResponseDto.dart';
import 'package:shoppingm8_fe/list/listApiProvider.dart';

class ListEditionDialog extends StatelessWidget {
  final GlobalKey<FormState> _listForm = GlobalKey<FormState>();
  final ListApiProvider _apiProvider = ListApiProvider();
  final String title;
  final ListResponseDto listDto;
  final Function onSuccess;

  String _name;

  ListEditionDialog({Key key, this.title, this.listDto, this.onSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Form(
              key: _listForm,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: true,
                      autocorrect: false,
                      initialValue: listDto.name,
                      decoration: InputDecoration(labelText: "list name"),
                      onSaved: (value) => _name = value,
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
    _listForm.currentState.save();
    ListRequestDto dto = ListRequestDto(name: _name);
    Response response = await _apiProvider.updateList(listDto.id, dto);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      onSuccess(ListResponseDto.fromJson(response.data));
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      ErrorDto error = ErrorDto.fromJson(response.data);
    }
  }
}