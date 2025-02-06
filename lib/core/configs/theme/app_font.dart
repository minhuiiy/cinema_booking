/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-10-16 22:05:14
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:flutter/material.dart';

///
/// `AppFont` class defines reusable text styles for consistent typography across the app.
///
class AppFont {
  // normal text bold
  static final kNormalBoldTextStyleWhite = TextStyle(
    fontFamily: 'Poppins',
    color: AppColors.textLight,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  // normal text white
  static final kNormalTextStyleWhite = TextStyle(
    fontFamily: 'Poppins',
    color: AppColors.textLight,
    fontSize: 18,
  );

  // normal text dark grey
  static final kNormalTextStyleGrey = TextStyle(
    fontFamily: 'Poppins',
    color: Color.fromARGB(255, 90, 74, 56),
    fontSize: 14,
    height: 1.5,
  );

  // mini title style white
  static final kMiniTitleTextStyleWhite = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    color: AppColors.textLight,
    fontSize: 22,
  );

  // mini title style primary
  static final kMiniTitleTextStylePrimary = TextStyle(
    fontFamily: 'Poppins',
    color: AppColors.primary,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  // title text white
  static final kTitleTextStyle = TextStyle(
    fontFamily: 'Poppins',
    color: AppColors.textLight,
    fontWeight: FontWeight.bold,
    fontSize: 30,
  );

  static final kTitleTextStylePrimary = TextStyle(
    fontFamily: 'Poppins',
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
    fontSize: 30,
  );
}
