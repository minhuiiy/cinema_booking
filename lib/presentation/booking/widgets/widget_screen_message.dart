import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:flutter/material.dart';

class WidgetScreenMessage extends StatelessWidget {
  String msg;

  WidgetScreenMessage({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(msg, style: AppFont.regular_gray4_14),
        ),
      ),
    );
  }
}
