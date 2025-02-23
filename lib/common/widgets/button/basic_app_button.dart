import 'package:flutter/material.dart';
import 'package:cinema_booking/core/configs/theme/app_color.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double height;
  final double textSize;
  final FontWeight weight;
  final bool isEnabled;

  const BasicAppButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.height = 50,
    this.textSize = 26,
    this.weight = FontWeight.bold,
    this.isEnabled = true, // Added to enable/disable button state
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isEnabled
                  ? AppColors.red
                  : AppColors.grey, // Disabled state color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed:
            isEnabled ? onPressed : null, // Disable button when not enabled
        child: Text(
          title,
          style: TextStyle(
            fontWeight: weight,
            color: Colors.white, // Ensured proper contrast
            fontSize: textSize,
          ),
        ),
      ),
    );
  }
}
