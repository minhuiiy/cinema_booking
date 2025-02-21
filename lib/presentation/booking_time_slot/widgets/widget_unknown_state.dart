import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:flutter/material.dart';

class WidgetUnknownState extends StatelessWidget {
  const WidgetUnknownState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text('Unknown state', style: AppFont.regular_gray4_14),
      ),
    );
  }
}
