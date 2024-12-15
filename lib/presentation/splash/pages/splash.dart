/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-10-15 10:16:59
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:flutter/material.dart';
import 'package:cinema_booking/common/helpers/is_dark_mode.dart';
import 'package:cinema_booking/core/configs/assets/app_images.dart';
import 'package:cinema_booking/presentation/intro/pages/get_started.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          context.isDarkMode ? AppImages.logoDark : AppImages.logoLight,
        ),
      ),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const GetStartedPage(),
        ),
      );
    }
  }
}
