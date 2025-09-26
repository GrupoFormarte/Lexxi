import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? w, h;
  final double m;

  const GradientButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.w = 150.0,
      this.h = 50.0,
      this.m = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      margin: EdgeInsets.symmetric(vertical: m),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        gradient: AppColors.linealGrdientGreen,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: context.textTheme.titleLarge,
        ),
      ),
    );
  }
}
