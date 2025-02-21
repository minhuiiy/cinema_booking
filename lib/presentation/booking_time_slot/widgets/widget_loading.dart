import 'package:flutter/material.dart';

class WidgetLoading extends StatelessWidget {
  const WidgetLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
