import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  AppToast._();

  static void _showToast({
    required String message,
    required Color backgroundColor,
    Color textColor = Colors.white,
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: 2,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  static void success({
    required String message,
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    _showToast(
      message: message,
      backgroundColor: Colors.green,
      toastLength: toastLength,
      gravity: gravity,
    );
  }

  static void error({
    required String message,
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    _showToast(
      message: message,
      backgroundColor: Colors.red,
      toastLength: toastLength,
      gravity: gravity,
    );
  }

  static void warning({
    required String message,
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    _showToast(
      message: message,
      backgroundColor: Colors.orange,
      toastLength: toastLength,
      gravity: gravity,
    );
  }

  static void info({
    required String message,
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    _showToast(
      message: message,
      backgroundColor: Colors.blue,
      toastLength: toastLength,
      gravity: gravity,
    );
  }
}