import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingm8_fe/common/dto/errorDto.dart';
import 'package:shoppingm8_fe/list/dto/listRequestDto.dart';
import 'package:shoppingm8_fe/list/listApiProvider.dart';

class ListCreationDialog extends StatelessWidget {
  final GlobalKey<FormState> _listForm = GlobalKey<FormState>();
  final String title;
  final ListApiProvider apiProvider;
  final Function onSuccess;

  String _name;

  ListCreationDialog({Key key, this.title, this.apiProvider, this.onSuccess}) : super(key: key);

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
    Response response = await apiProvider.createList(dto);
    if (response.statusCode == 201) {
      Navigator.pop(context);
      onSuccess();
    } else {
      Navigator.pop(context);
      ErrorDto error = json.decode(response.data.toString());
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Could not create list"),
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