import 'package:flutter/material.dart';

class Mecha extends StatelessWidget {
  const Mecha({super.key,  this.w,  this.h});
  final double? w, h;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      height: h,
      child: Image.asset(
        'assets/mechas.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
