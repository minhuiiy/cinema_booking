/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2025-02-16 08:39:35
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'dart:ui';

import 'package:cinema_booking/common/widgets/button/basic_app_button.dart';
import 'package:cinema_booking/common/widgets/snackbar/custom_snackbar.dart';
import 'package:cinema_booking/common/widgets/space/widget_spacer.dart';
import 'package:cinema_booking/common/widgets/texts/gradient_text.dart';
import 'package:cinema_booking/core/configs/assets/app_images.dart';
import 'package:cinema_booking/core/configs/assets/app_vectors.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/presentation/about_page/bloc/user_bloc.dart';
import 'package:cinema_booking/presentation/about_page/widgets/age_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

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

  void updateAge(int age) {
    setState(() {
      selectedAge = age;
    });
  }

  String _genderText(String gender) {
    switch (gender) {
      case 'Male':
        return 'Nam';
      case 'Female':
        return 'Nữ';
      default:
        return gender;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoBloc, UserInfoState>(
      listener: (context, state) {
        if (state is UserInfoEdit) {
          if (state.isSuccess) {
            CustomSnackBar.success(context, msg: "Cập nhật thông tin thành công");
          }

          if (state.isFailure) {
            CustomSnackBar.failure(context, msg: "Cập nhật thông tin thất bại");
          }
        }
      },
      child: BlocBuilder<UserInfoBloc, UserInfoState>(
        builder: (context, state) {
          if (state is UserInfoLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is UserInfoEdit) {
            return Scaffold(
              backgroundColor: AppColors.darkBackground,
              appBar: AppBar(
                backgroundColor: AppColors.darkBackground,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    final router = GoRouter.of(context);
                    if (router.canPop()) {
                      context.pop();
                    } else {
                      context.go('/');
                    }
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: Text("Bỏ qua", style: AppFont.medium_white_18),
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
                          imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
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
                                text: "THÔNG TIN CÁ NHÂN",
                                textStyle: AppFont.semibold_white_30.copyWith(
                                  fontFamily: 'Oswald',
                                ),
                              ),
                              WidgetSpacer(width: 10),
                            ],
                          ),
                          const WidgetSpacer(height: 25),
                          _textField("Email", _email, state.userInfo.email),
                          const WidgetSpacer(height: 20),
                          _textField(
                            "Họ và tên",
                            _fullName,
                            state.userInfo.fullName,
                          ),
                          const WidgetSpacer(height: 20),
                          _textField("Mật khẩu", _password, "Mật khẩu"),
                          const WidgetSpacer(height: 20),
                          _textField(
                            "Xác nhận mật khẩu",
                            _confirmPassword,
                            "Xác nhận mật khẩu",
                          ),
                          const WidgetSpacer(height: 30),
                          _genderSelection(state),
                          const WidgetSpacer(height: 20),
                          _ageSelection(state.userInfo.age),
                          const WidgetSpacer(height: 35),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: BasicAppButton(
                              onPressed: () async {
                                _onFormSubmitted(state);
                              },
                              title: "Cập nhật thông tin",
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

          return Container();
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
      style: AppFont.medium_white_18,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: AppFont.medium_white_18,
        labelText: fetchInfo,
        labelStyle: AppFont.medium_white_18,
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

  Widget _genderSelection(UserInfoEdit state) {
    return Column(
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                style: AppFont.medium_white_18,
                children: [
                  TextSpan(text: "Giới tính:    ", style: AppFont.medium_white_22),
                  TextSpan(
                    text: selectedGender == "" ? _genderText(state.userInfo.gender) : _genderText(selectedGender),
                    style: AppFont.medium_white_22.copyWith(
                      color:
                          selectedGender == ""
                              ? (state.userInfo.gender) == "Male"
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
        const WidgetSpacer(height: 35),
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

  Widget _genderAvatar(String gender, String imagePath, UserInfoEdit state) {
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
                    ? (state.userInfo.gender) == gender
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
        Row(children: [Text("Tuổi:", style: AppFont.medium_white_22)]),
        const WidgetSpacer(height: 15),
        AgeSelector(onAgeSelected: updateAge, age: age),
      ],
    );
  }

  void _onFormSubmitted(UserInfoEdit state) {
    BlocProvider.of<UserInfoBloc>(context).add(
      Submitted(
        email: _email.text.isEmpty ? state.userInfo.email : _email.text,
        password: _password.text,
        confirmPassword: _confirmPassword.text,
        displayName:
            _fullName.text.isEmpty ? state.userInfo.fullName : _fullName.text,
        age: selectedAge,
        gender: selectedGender == "" ? state.userInfo.gender : selectedGender,
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
