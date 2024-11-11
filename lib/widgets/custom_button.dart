import 'package:flutter/material.dart';

import '../presentation/typography.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButton({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Colors.black38,
        ),
        child: Text(
          text,
          style: AppTypography.basicStyle.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
