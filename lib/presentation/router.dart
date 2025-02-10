/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-17 21:30:56
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

// ignore_for_file: constant_identifier_names
import 'package:cinema_booking/presentation/home/home_main.dart';
import 'package:cinema_booking/presentation/login/pages/login.dart';
import 'package:cinema_booking/presentation/login/pages/register.dart';
import 'package:cinema_booking/presentation/splash/splash.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String HOME = '/';
  static const String SPLASH = '/splash';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HOME:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case SPLASH:
        return MaterialPageRoute(builder: (_) => SplashPage());

      case LOGIN:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case REGISTER:
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
