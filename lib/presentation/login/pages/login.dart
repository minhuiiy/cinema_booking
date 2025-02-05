import 'package:cinema_booking/core/configs/assets/app_images.dart';
import 'package:cinema_booking/core/configs/assets/app_vectors.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBackground, // Dark background
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              SizedBox(
                width: 370,
                child: Image.asset(
                  AppImages.logoCT,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Image.asset(
                      AppImages.logo,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "Watch thousands of hit movies and TV series for free",
                      textAlign: TextAlign.center,
                      style: AppFont.kNormalTextStyleWhite.copyWith(fontSize: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              buildLoginButton(
                svgIconPath: AppVectors.iconGoogle,
                text: "Continue with Google",
                color: AppColors.red,
                onPressed: () {},
              ),
              buildLoginButton(
                svgIconPath: AppVectors.iconFacebook,
                text: "Continue with Facebook",
                color: AppColors.blue,
                onPressed: () {},
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Sign up",
                  style: AppFont.kNormalTextStyleWhite.copyWith(fontSize: 19),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton({
    required String svgIconPath,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgIconPath,
            height: 24,
            width: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: AppFont.kNormalTextStyleWhite.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
