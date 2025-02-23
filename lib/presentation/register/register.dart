import 'package:cinema_booking/common/bloc/authentication/authentication_bloc.dart';
import 'package:cinema_booking/common/widgets/button/basic_app_button.dart';
import 'package:cinema_booking/core/configs/assets/app_images.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/presentation/register/bloc/register_bloc.dart';
import 'package:cinema_booking/presentation/register/widgets/age_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => RegisterBloc(), child: const SignupPage());
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  String selectedGender = 'Male';
  int selectedAge = 18;

  bool get isPopulated =>
      _email.text.isNotEmpty &&
      _password.text.isNotEmpty &&
      _confirmPassword.text.isNotEmpty &&
      _fullName.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void updateAge(int age) {
    setState(() {
      selectedAge = age;
    });
  }

  @override
  void initState() {
    super.initState();
    _email.addListener(_onEmailChanged);
    _password.addListener(_onPasswordChanged);
    _confirmPassword.addListener(_onConfirmPasswordChanged);
    _fullName.addListener(_onNameChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Registering ... '), CircularProgressIndicator()],
                ),
              ),
            );
        }

        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }

        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Registering Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            TextButton(onPressed: () {}, child: Text("Skip", style: AppFont.kNormalTextStyleWhite)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(children: [Text("ABOUT ME", style: AppFont.kTitleTextStyle)]),
                const SizedBox(height: 25),
                _textField("Email", _email),
                const SizedBox(height: 20),
                _textField("Full Name", _fullName),
                const SizedBox(height: 20),
                _textField("Password", _password),
                const SizedBox(height: 20),
                _textField("Conirm Password", _confirmPassword),
                const SizedBox(height: 30),
                _genderSelection(),
                const SizedBox(height: 20),
                _ageSelection(),
                const SizedBox(height: 35),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BasicAppButton(
                    onPressed: () async {
                      _onFormSubmitted();
                    },
                    title: "Sign up",
                    textSize: 22,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: AppFont.kNormalTextStyleWhite,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: AppFont.kNormalTextStyleWhite,
        labelText: label,
        labelStyle: AppFont.kNormalTextStyleWhite,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.zero,
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }

  Widget _genderSelection() {
    return Column(
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                style: AppFont.kNormalTextStyleWhite,
                children: [
                  TextSpan(text: "Gender:    ", style: AppFont.kMiniTitleTextStyleWhite),
                  TextSpan(
                    text: selectedGender,
                    style: AppFont.kMiniTitleTextStyleWhite.copyWith(
                      color: selectedGender == "Male" ? AppColors.blue : AppColors.pink,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 35),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _genderAvatar('Male', AppImages.boyAvatar),
            _genderAvatar('Female', AppImages.girlAvatar),
          ],
        ),
      ],
    );
  }

  Widget _genderAvatar(String gender, String imagePath) {
    return GestureDetector(
      onTap: () => setState(() => selectedGender = gender),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: selectedGender == gender ? Colors.red : Colors.white12,
        child: ClipOval(
          child: SizedBox(width: 60, height: 60, child: Image.asset(imagePath, fit: BoxFit.cover)),
        ),
      ),
    );
  }

  Widget _ageSelection() {
    return Column(
      children: [
        Row(children: [Text("Age:", style: AppFont.kMiniTitleTextStyleWhite)]),
        const SizedBox(height: 15),
        AgeSelector(onAgeSelected: updateAge),
      ],
    );
  }

  void _onEmailChanged() {
    context.read<RegisterBloc>().add(EmailChanged(email: _email.text));
  }

  void _onPasswordChanged() {
    context.read<RegisterBloc>().add(
      PasswordChanged(password: _password.text, confirmPassword: _confirmPassword.text),
    );
  }

  void _onConfirmPasswordChanged() {
    context.read<RegisterBloc>().add(
      ConfirmPasswordChanged(password: _password.text, confirmPassword: _confirmPassword.text),
    );
  }

  void _onNameChanged() {
    context.read<RegisterBloc>().add(NameChanged(name: _fullName.text));
  }

  void _onFormSubmitted() {
    context.read<RegisterBloc>().add(
      Submitted(
        email: _email.text,
        password: _password.text,
        confirmPassword: _confirmPassword.text,
        displayName: _fullName.text,
        age: selectedAge,
        gender: selectedGender,
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _fullName.dispose();
    super.dispose();
  }
}
