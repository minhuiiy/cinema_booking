import 'package:cinema_booking/core/configs/theme/app_color.dart';
import 'package:cinema_booking/core/configs/theme/app_font.dart';
import 'package:cinema_booking/presentation/login/widgets/age_selector.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String selectedGender = 'Male';
  int selectedAge = 25;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              child: Text(
                "Skip",
                style: AppFont.kNormalTextStyleWhite,
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text(
                    "ABOUT ME",
                    style: AppFont.kTitleTextStyle,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  style: AppFont.kNormalTextStyleWhite,
                  decoration: InputDecoration(
                    hintText: "Email", // Appears before user types
                    hintStyle: AppFont.kNormalTextStyleWhite,
                    labelText: "Email", // Moves up when text is entered
                    labelStyle: AppFont.kNormalTextStyleWhite,
                    floatingLabelBehavior:
                        FloatingLabelBehavior.auto, // Label only appears when typing
                    contentPadding: EdgeInsets.zero, // Prevents extra spacing
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: TextField(
                  style: AppFont.kNormalTextStyleWhite,
                  decoration: InputDecoration(
                    hintText: "Full Name", // Appears before user types
                    hintStyle: AppFont.kNormalTextStyleWhite,
                    labelText: "Full Name", // Moves up when text is entered
                    labelStyle: AppFont.kNormalTextStyleWhite,
                    floatingLabelBehavior:
                        FloatingLabelBehavior.auto, // Label only appears when typing
                    contentPadding: EdgeInsets.zero, // Prevents extra spacing
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: AppFont.kNormalTextStyleWhite, // Default style
                      children: [
                        TextSpan(
                          text: "Gender:    ",
                          style: AppFont.kMiniTitleTextStyleWhite,
                        ),
                        // Static part
                        TextSpan(
                          text: selectedGender, // Dynamic gender text
                          style: AppFont.kMiniTitleTextStyleWhite.copyWith(
                            color: selectedGender == "Male"
                                ? AppColors.blue
                                : AppColors.pink, // Color logic
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
                  GestureDetector(
                    onTap: () => setState(() => selectedGender = 'Male'),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: selectedGender == 'Male' ? Colors.red : Colors.white12,
                      child: ClipOval(
                        child: SizedBox(
                          width: 60, // Match double the radius to fill the circle
                          height: 60, // Match double the radius to fill the circle
                          child: Image.asset(
                            'assets/images/man.jpg',
                            fit: BoxFit.cover, // Ensures full coverage within the circle
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => selectedGender = 'Female'),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: selectedGender == 'Female' ? Colors.red : Colors.white12,
                      child: ClipOval(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.asset(
                            'assets/images/girl.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Text(
                    "Age:",
                    style: AppFont.kMiniTitleTextStyleWhite,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              AgeSelector(),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Done"),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
