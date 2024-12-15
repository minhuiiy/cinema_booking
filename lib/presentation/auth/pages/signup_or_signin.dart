/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-10-15 10:16:59
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cinema_booking/common/widgets/appbar/app_bar.dart';
import 'package:cinema_booking/common/widgets/button/basic_app_button.dart';
import 'package:cinema_booking/common/helpers/is_dark_mode.dart';
import 'package:cinema_booking/core/configs/assets/app_images.dart';
import 'package:cinema_booking/core/configs/assets/app_vectors.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/presentation/auth/pages/signup.dart';
import 'package:cinema_booking/presentation/auth/pages/singin.dart';

class SignupOrSignin extends StatelessWidget {
  const SignupOrSignin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BasicAppBar(),
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(AppVectors.unionTop),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(AppVectors.unionBottom),
          ),

          //
          // TODO: Case use BackGround
          //
          // Align(
          //   alignment: Alignment.bottomLeft,
          //   child: Image.asset(AppImages.chooseAuthBG),
          // ),
          //

          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    context.isDarkMode ? AppImages.logoDark : AppImages.logoLight,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Flutter Journey',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.isDarkMode ? AppColors.white : AppColors.metalDark,
                      fontSize: 29,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Journey on the Road to Becoming a Flutter Master 🚀',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: context.isDarkMode ? AppColors.greyTitle : AppColors.grey,
                      fontSize: 19,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: BasicAppButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SignupPage(),
                              ),
                            );
                          },
                          title: "Register",
                          textSize: 20,
                          weight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 21,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color:
                                  context.isDarkMode ? AppColors.white : AppColors.darkBackground,
                              fontSize: 21,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SigninPage(),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
