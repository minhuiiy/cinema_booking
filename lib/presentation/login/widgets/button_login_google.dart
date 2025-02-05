/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-10-16 21:56:08
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/core/configs/assets/app_vectors.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonLoginGoogle extends StatelessWidget {
  const ButtonLoginGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.googleButtonBackground,
            border: Border.all(
              width: 0.2,
              color: AppColors.googleButtonBorder,
            ),
            shape: BoxShape.rectangle),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: SvgPicture.asset(
                AppVectors.iconGoogle,
                width: 24,
                height: 24,
              ),
            ),
            Text(
              'Google',
              style: AppFont.kNormalTextStyleGrey,
            )
          ],
        ),
      ),
    );
  }
}
