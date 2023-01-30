import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle titleTextStyle(
      {double size = 20, Color color = Colors.white}) {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: size, color: color);
  }

  static TextStyle bodyTextStyle(
      {double size = 18, Color color = Colors.white}) {
    return TextStyle(
        fontWeight: FontWeight.normal, fontSize: size, color: color);
  }
}
