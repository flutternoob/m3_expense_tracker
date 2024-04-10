import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String? text;
  final VoidCallback? handler;

  const AdaptiveFlatButton(this.text, this.handler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Platform.isIOS
        ? CupertinoButton(
      child: Text(
        text!,
        style: TextStyle(
            color: themeData.primaryColor,
            fontWeight: FontWeight.bold),
      ),
      onPressed: handler,
    )
        : FlatButton(
      child: Text(
        text!,
        style: TextStyle(
            color: themeData.primaryColor,
            fontWeight: FontWeight.bold),
      ),
      onPressed: handler,
    );
  }
}
