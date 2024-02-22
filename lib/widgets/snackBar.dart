import 'package:flutter/material.dart';

class CustomSnackBar {
  CustomSnackBar(BuildContext context, Widget content,
      {SnackBarAction? snackBarAction, Color backgroundColor = Colors.black}) {
    final SnackBar snackBar = SnackBar(
        action: snackBarAction,
        backgroundColor: backgroundColor,
        content: content,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating);

    // ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class CustomSnackBarArtist {
  CustomSnackBarArtist(BuildContext context, Widget content,
      {SnackBarAction? snackBarAction, Color backgroundColor = Colors.black}) {
    final SnackBar snackBar = SnackBar(
        action: snackBarAction,
        backgroundColor: backgroundColor,
        content: content,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating);

    // ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
