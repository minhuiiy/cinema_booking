/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-10-16 21:57:09
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/assets/app_images.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:flutter/material.dart';

class WidgetTopWelcome extends StatelessWidget {
  const WidgetTopWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        WidgetSpacer(height: 41),
        SizedBox(
          width: 370,
          child: Image.asset(
            AppImages.logoCT,
            fit: BoxFit.cover,
          ),
        ),
        WidgetSpacer(height: 20),
        Text(
          'Welcome Buddies',
          style: AppFont.kTitleTextStyle,
        ),
        Text(
          ' Login to book your seat, I said its your seat',
          style: AppFont.kNormalTextStyleWhite,
        ),
        WidgetSpacer(height: 30),
      ],
    );
  }
}
