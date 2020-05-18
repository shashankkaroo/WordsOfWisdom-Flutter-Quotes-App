import 'package:flutter/material.dart';

class UiUtils {

  static showInSnackBar(value, context, _scaffoldKey)
  {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0),
        ),
      //backgroundColor: Colors.blue,
      duration: Duration(seconds: 4),
      ));
  }
}