import 'package:flutter/material.dart';
import 'package:lexxi/src/global/design_system/color_palette.dart';
import 'package:lottie/lottie.dart';

class SignupLoadingOverlay extends StatefulWidget {
  const SignupLoadingOverlay({super.key});

  @override
  State<SignupLoadingOverlay> createState() => _SignupLoadingOverlayState();
}

class _SignupLoadingOverlayState extends State<SignupLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: ColorPalette.gradientBlueBackground,
      ),
      child: Center(
        child: Lottie.asset(
          'assets/json/profile-settings.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration * 9
              ..repeat();
          },
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}