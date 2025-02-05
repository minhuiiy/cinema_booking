import 'package:flutter/material.dart';

class AgeSelector extends StatefulWidget {
  const AgeSelector({super.key});

  @override
  State<AgeSelector> createState() => _AgeSelectorState();
}

class _AgeSelectorState extends State<AgeSelector> {
  final int minAge = 10;
  final int maxAge = 90;
  int selectedAge = 18; // Default start age

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.2,
      initialPage: selectedAge - minAge, // Set start page to 18
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) {
          setState(() {
            selectedAge = minAge + index;
          });
        },
        itemCount: maxAge - minAge + 1,
        itemBuilder: (context, index) {
          int age = minAge + index;
          bool isSelected = age == selectedAge;

          return Center(
            child: Text(
              "$age",
              style: TextStyle(
                fontSize: isSelected ? 24 : 18, // Enlarge selected age
                color: isSelected ? Colors.red : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
