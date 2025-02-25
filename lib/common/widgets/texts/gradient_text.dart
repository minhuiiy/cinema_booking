/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2025-01-24 08:46:47
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;

  const GradientText({super.key, required this.text, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback:
          (bounds) => LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
      child: Text(text, style: textStyle),
    );
  }
}
