/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-17 21:15:23
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/presentation/login/bloc/login_bloc.dart';
import 'package:cinema_booking/presentation/login/widgets/appbar_welcome.dart';
import 'package:cinema_booking/presentation/login/widgets/bottom_signup.dart';
import 'package:cinema_booking/presentation/login/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: Container(
          color: AppColors.defaultColor,
          child: ListView(
            children: <Widget>[
              WidgetTopWelcome(),
              WidgetLoginForm(),
              WidgetBottomSignUp(),
            ],
          ),
        ),
      ),
    );
  }
}
