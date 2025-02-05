/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-10-16 21:56:29
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/common/bloc/authentication/authentication_bloc.dart';
import 'package:cinema_booking/presentation/login/bloc/login_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetLoginForm extends StatefulWidget {
  const WidgetLoginForm({super.key});

  @override
  State<WidgetLoginForm> createState() => _WidgetLoginFormState();
}

class _WidgetLoginFormState extends State<WidgetLoginForm> {
  late AuthenticationBloc _authenticationBloc;
  late LoginBloc _loginBloc;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _authenticationBloc.add(LoggedIn());
        }

        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Login Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }

        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Processing ...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            color: AppColors.white,
          ),
          child: Form(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login to your account',
                    style: AppFont.kNormalTextStyleWhite,
                  ),
                ),
                WidgetSpacer(height: 20),
                _buildTextFieldUsername(),
                WidgetSpacer(height: 14),
                _buildTextFieldPassword(),
                WidgetSpacer(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot password ?',
                    style: AppFont.kNormalTextStyleGrey,
                  ),
                ),
                WidgetSpacer(height: 20),
                _buildButtonLogin(state),
                WidgetSpacer(height: 30),
                _buildTextOr(),
                WidgetSpacer(height: 20),
                _buildSocialLogin(),
              ],
            ),
          ),
        );
      }),
    );
  }

  _buildSocialLogin() {
    return SizedBox(
      height: 40,
      child: Row(
        children: <Widget>[
          // ButtonLoginGoogle(),
          // SizedBox(width: 20),
          // ButtonLoginFacebook(),
        ],
      ),
    );
  }

  _buildTextOr() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Divider(color: AppColors.black.withAlpha(30)),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: Text(
                'Or',
                style: AppFont.kNormalTextStyleGrey,
              ),
            ),
          ),
        )
      ],
    );
  }

  _buildButtonLogin(LoginState state) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isRegisterButtonEnabled()
              ? AppColors.defaultColor
              : AppColors.greyLight.withAlpha(50), // Màu nền của nút
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
        ),
        onPressed: () {
          if (isRegisterButtonEnabled()) {
            _loginBloc.add(LoginSubmitEmailPasswordEvent(
              email: _emailController.text,
              password: _passwordController.text,
            ));
          }
        },
        child: Text(
          'Login'.toUpperCase(),
          style: AppFont.kNormalBoldTextStyleWhite,
        ),
      ),
    );
  }

  bool isRegisterButtonEnabled() {
    return _loginBloc.state.isFormValid && isPopulated && !_loginBloc.state.isSubmitting;
  }

  _buildTextFieldPassword() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
      ),
      child: Center(
        child: TextFormField(
          controller: _passwordController,
          onChanged: (value) {
            _loginBloc.add(LoginPasswordChanged(password: value));
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) {
            return !_loginBloc.state.isPasswordValid ? 'Invalid Password' : null;
          },
          style: AppFont.kNormalTextStyleGrey,
          maxLines: 1,
          keyboardType: TextInputType.text,
          obscureText: true,
          textAlign: TextAlign.left,
          decoration: InputDecoration.collapsed(
            hintText: 'Password',
          ),
        ),
      ),
    );
  }

  _buildTextFieldUsername() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
      ),
      child: Center(
        child: TextFormField(
          controller: _emailController,
          onChanged: (value) {
            _loginBloc.add(LoginEmailChanged(email: value));
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) {
            return !_loginBloc.state.isEmailValid ? 'Invalid Email' : null;
          },
          style: AppFont.kNormalTextStyleGrey,
          maxLines: 1,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.left,
          decoration: InputDecoration.collapsed(
            hintText: 'Email',
          ),
        ),
      ),
    );
  }
}
