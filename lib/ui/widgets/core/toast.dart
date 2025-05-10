import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

void showCustomToast({
  required String message,
  Color backgroundColor = const Color(0xFF212121),
  Color textColor = Colors.white,
  int durationInSeconds = 3,
  ToastGravity? gravity,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: gravity ?? ToastGravity.CENTER,
    timeInSecForIosWeb: durationInSeconds,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: 16.0,
  );
}
