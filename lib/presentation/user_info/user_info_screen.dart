import 'dart:ui';

import 'package:cinema_booking/common/widgets/button/basic_app_button.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/common/widgets/texts/gradient_text.dart';
import 'package:cinema_booking/core/configs/assets/app_images.dart';
import 'package:cinema_booking/core/configs/assets/app_vectors.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/presentation/user_info/bloc/user_bloc.dart';
import 'package:cinema_booking/presentation/user_info/widgets/age_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UserInfoBloc()..add(LoadUserInfo()), // Provide the Bloc
      child: const UserInfoPage(), // Ensure UserInfoPage has access to the Bloc
    );
  }
}

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  String selectedGender = "";
  int selectedAge = 18;

  bool get isPopulated =>
      _email.text.isNotEmpty &&
      _password.text.isNotEmpty &&
      _confirmPassword.text.isNotEmpty &&
      _fullName.text.isNotEmpty;

  bool isUserInfoButtonEnabled(UserInfoState state) {
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoBloc, UserInfoState>(
      listener: (context, state) {
        print(state.toString());
        if (state.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('UserInfo update success'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );
        }

        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('UserInfo update Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<UserInfoBloc, UserInfoState>(
        builder: (context, state) {
          if (state.userInfo == null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('UserInfo fetching ... '),
                CircularProgressIndicator(),
              ],
            );
          } else {
            return Scaffold(
              backgroundColor: AppColors.darkBackground,
              appBar: AppBar(
                backgroundColor: AppColors.darkBackground,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: Text("Skip", style: AppFont.kNormalTextStyleWhite),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(AppVectors.unionTop),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SvgPicture.asset(AppVectors.unionBottom),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Opacity(
                        opacity: 0.3,
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 5,
                            sigmaY: 5,
                          ), // Làm mờ ảnh
                          child: Image.asset(
                            AppImages.ticket,
                            width: MediaQuery.of(context).size.width * 0.4,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.3,
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Image.asset(AppImages.logo),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GradientText(
                                text: "ABOUT ME",
                                textStyle: AppFont.kTitleTextStyle.copyWith(
                                  fontFamily: 'Oswald',
                                ),
                              ),
                              WidgetSpacer(width: 10),
                            ],
                          ),
                          const WidgetSpacer(height: 25),
                          _textField(
                            "Email",
                            _email,
                            state.userInfo?.email ?? "",
                          ),
                          const WidgetSpacer(height: 20),
                          _textField(
                            "Full Name",
                            _fullName,
                            state.userInfo?.fullName ?? "",
                          ),
                          const WidgetSpacer(height: 20),
                          _textField("Password", _password, "Password"),
                          const WidgetSpacer(height: 20),
                          _textField(
                            "Confirm Password",
                            _confirmPassword,
                            "Confirm Password",
                          ),
                          const WidgetSpacer(height: 30),
                          _genderSelection(state),
                          const WidgetSpacer(height: 20),
                          _ageSelection(state.userInfo!.age),
                          const WidgetSpacer(height: 35),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: BasicAppButton(
                              onPressed: () async {
                                _onFormSubmitted(state);
                              },
                              title: "Update Info",
                              textSize: 22,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller,
    String fetchInfo,
  ) {
    return TextField(
      controller: controller,
      style: AppFont.kNormalTextStyleWhite,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: AppFont.kNormalTextStyleWhite,
        labelText: fetchInfo,
        labelStyle: AppFont.kNormalTextStyleWhite,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.zero,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.textLight),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.textLight),
        ),
      ),
    );
  }

  Widget _genderSelection(UserInfoState state) {
    return Column(
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                style: AppFont.kNormalTextStyleWhite,
                children: [
                  TextSpan(
                    text: "Gender:    ",
                    style: AppFont.kMiniTitleTextStyleWhite,
                  ),
                  TextSpan(
                    text: selectedGender,
                    style: AppFont.kMiniTitleTextStyleWhite.copyWith(
                      color:
                          selectedGender == ""
                              ? (state.userInfo?.gender ?? "Male") == "Male"
                                  ? AppColors.blue
                                  : AppColors.defaultColor
                              : selectedGender == "Male"
                              ? AppColors.blue
                              : AppColors.defaultColor,
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
            _genderAvatar('Male', AppImages.boyAvatar, state),
            _genderAvatar('Female', AppImages.girlAvatar, state),
          ],
        ),
      ],
    );
  }

  Widget _genderAvatar(String gender, String imagePath, UserInfoState state) {
    return GestureDetector(
      onTap: () => setState(() => selectedGender = gender),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color:
                selectedGender == ""
                    ? (state.userInfo?.gender ?? "Male") == gender
                        ? AppColors.defaultColor
                        : Colors.white24
                    : (selectedGender == gender)
                    ? AppColors.defaultColor
                    : Colors.white24,
            width: 3,
          ),
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(imagePath),
        ),
      ),
    );
  }

  Widget _ageSelection(int age) {
    return Column(
      children: [
        Row(children: [Text("Age:", style: AppFont.kMiniTitleTextStyleWhite)]),
        const SizedBox(height: 15),
        AgeSelector(onAgeSelected: updateAge, age: age),
      ],
    );
  }

  void _onFormSubmitted(UserInfoState state) {
    BlocProvider.of<UserInfoBloc>(context).add(
      Submitted(
        email: _email.text.isEmpty ? state.userInfo!.email : _email.text,
        password: _password.text,
        confirmPassword: _confirmPassword.text,
        displayName:
            _fullName.text.isEmpty ? state.userInfo!.fullName : _fullName.text,
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
