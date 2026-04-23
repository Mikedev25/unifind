import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
    final IconData? icon;
  final Widget? customChild;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    this.icon,
    this.customChild,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: customChild ??
            Icon(
              icon,
              color: Colors.white,
              size: 40,
          ),
        ),
    );
  }
}
