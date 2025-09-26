import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';

class MedalGradient extends StatelessWidget {
  const MedalGradient({super.key, required this.controller, this.onInit});
  final List<RiveAnimationController> controller;
  final Function(Artboard)? onInit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            width: 100.w,
            height: 100.w,
            child: RiveAnimation.asset(
              'assets/medallon_degradado.riv',
              controllers: controller,
              onInit: onInit,
            )),
      ],
    );
  }
}
