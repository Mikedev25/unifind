import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: const Color(0xFF2ECC71),
      buttonBackgroundColor: const Color(0xFF2ECC71),
      animationDuration: Duration(milliseconds: 400),
      height: 70,
      index: currentIndex,
      items: const [
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.message, size: 30, color: Colors.white),
        Icon(Icons.add_circle, size: 30, color: Colors.white),
        Icon(Icons.search, size: 30, color: Colors.white),
        Icon(Icons.person, size: 30, color: Colors.white),
      ],
      onTap: (index) {
        onTap(index);
      },
    );
  }
}