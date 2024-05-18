import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toastMessage({
  required dynamic message,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
  int timeInSecForIosWeb = 2,
  Toast toastLength = Toast.LENGTH_SHORT,
  ToastGravity gravity = ToastGravity.CENTER,
}) {
  Fluttertoast.showToast(
    msg: "$message",
    toastLength: toastLength,
    gravity: gravity,
    timeInSecForIosWeb: timeInSecForIosWeb,
    backgroundColor: backgroundColor,
    textColor: textColor,
    webPosition: "center",
    webBgColor: "black",
    webShowClose: true,
    fontSize: 16.0,
  );
}
