import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? w, h;
  final double m;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.w = 120.0,
    this.h = 50.0,
    this.m = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      margin: EdgeInsets.symmetric(vertical: m),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: AppColors.linealGrdientGreen,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
