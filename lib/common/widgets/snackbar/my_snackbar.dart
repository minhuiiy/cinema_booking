import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showLoading(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Processing ...'),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
  }

  static void hideLoading(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  static void failure(BuildContext context, {String msg = "Failure"}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(msg),
              Icon(Icons.error),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
  }

  static void success(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: <Widget>[
              Text(msg),
            ],
          ),
          backgroundColor: AppColors.defaultColor,
        ),
      );
  }
}
