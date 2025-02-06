import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/core/configs/assets/app_vectors.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/common/bloc/authentication/authentication_bloc.dart';
import 'package:cinema_booking/presentation/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class WidgetSignInForm extends StatefulWidget {
  const WidgetSignInForm({super.key});

  @override
  State<WidgetSignInForm> createState() => _WidgetSignInFormState();
}

class _WidgetSignInFormState extends State<WidgetSignInForm> {
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Failed!'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state.isSubmitting) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Processing...'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColors.black.withAlpha(70), // Dark mode card
            ),
            child: Form(
              child: Column(
                children: <Widget>[
                  _buildTextField("Email", _emailController, Icons.email),
                  const WidgetSpacer(height: 14),
                  _buildTextField("Password", _passwordController, Icons.lock, isPassword: true),
                  const WidgetSpacer(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot password?',
                      style: AppFont.kNormalTextStyleGrey.copyWith(color: Colors.orangeAccent),
                    ),
                  ),
                  const WidgetSpacer(height: 35),
                  _buildButtonLogin(state),
                  const WidgetSpacer(height: 30),
                  _buildTextOr(),
                  const WidgetSpacer(height: 20),
                  _buildSocialLogin(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon,
      {bool isPassword = false}) {
    return Container(
      height: 60, // Increased height for better centering
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white.withAlpha(10), // Dark transparent input fields
      ),
      child: Center(
        child: TextFormField(
          onChanged: (value) {
            _loginBloc.add(LoginEmailChanged(email: value));
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) {
            return isPassword
                ? !_loginBloc.state.isPasswordValid
                    ? 'Invalid Password'
                    : null
                : !_loginBloc.state.isEmailValid
                    ? 'Invalid Email'
                    : null;
          },
          maxLines: 1,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.left,
          controller: controller,
          obscureText: isPassword,
          style: AppFont.kNormalTextStyleWhite,
          textAlignVertical: TextAlignVertical.center, // Centers text inside field
          decoration: InputDecoration(
            labelText: hint, // Floating label text
            labelStyle: AppFont.kNormalTextStyleGrey.copyWith(fontSize: 16),
            floatingLabelBehavior: FloatingLabelBehavior.auto, // Always show label
            alignLabelWithHint: true, // Aligns label correctly
            contentPadding: const EdgeInsets.symmetric(vertical: 15), // Centers hint
            border: InputBorder.none,
            prefixIcon: Icon(icon, color: Colors.white70), // Add an icon inside input
          ),
        ),
      ),
    );
  }

  Widget _buildButtonLogin(LoginState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isRegisterButtonEnabled()
                ? AppColors.red
                : AppColors.primary, // Movie-themed red button
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            'LOGIN',
            style: AppFont.kNormalBoldTextStyleWhite.copyWith(
                fontSize: 18,
                color: isRegisterButtonEnabled() ? AppColors.textLight : AppColors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildTextOr() {
    return Stack(
      children: <Widget>[
        Align(alignment: Alignment.center, child: Divider(color: Colors.white24)),
        Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('Or', style: AppFont.kNormalTextStyleGrey),
          ),
        ),
      ],
    );
  }

  bool isRegisterButtonEnabled() {
    return _loginBloc.state.isFormValid && isPopulated && !_loginBloc.state.isSubmitting;
  }

  Widget _buildSocialLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: SvgPicture.asset(AppVectors.iconGoogle, height: 30),
          onPressed: () {},
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: SvgPicture.asset(AppVectors.iconFacebook, height: 30),
          onPressed: () {},
        ),
      ],
    );
  }
}
