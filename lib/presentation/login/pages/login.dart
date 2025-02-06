import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/presentation/login/bloc/login_bloc.dart';
import 'package:cinema_booking/presentation/login/widgets/bottom_signup.dart';
import 'package:cinema_booking/presentation/login/widgets/signin_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBackground, // Dark background
        body: BlocProvider(
          create: (context) => LoginBloc(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '🎟️ Sign in',
                      style: AppFont.kTitleTextStyle.copyWith(fontSize: 45),
                    ),
                  ),
                  SizedBox(height: 50),
                  const WidgetSignInForm(),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  const WidgetBottomSignUp(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
