import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';

class FlatColorButton extends StatelessWidget {
  final Widget text;
  final Color color;
  final VoidCallback onPressed;
  final double padding;

  const FlatColorButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.padding = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
        gradient: context.darkmode
            ? AppColors.linealGrdientGreen
            : AppColors.linealGradientBlueDark,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Center(child: text),
      ),
    );
  }
}
