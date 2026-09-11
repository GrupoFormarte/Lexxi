import 'package:flutter/material.dart';
import 'package:lexxi/src/global/design_system/color_palette.dart';
import 'package:lottie/lottie.dart';

class SignupLoadingOverlay extends StatefulWidget {
  final VoidCallback? onAnimationComplete;

  const SignupLoadingOverlay({super.key, this.onAnimationComplete});

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
  void didUpdateWidget(covariant SignupLoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onAnimationComplete == null &&
        widget.onAnimationComplete != null &&
        _controller.duration != null) {
      _controller
        ..stop()
        ..value = 0;
      _controller.forward().whenCompleteOrCancel(widget.onAnimationComplete!);
    }
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
            _controller.duration = composition.duration;
            final callback = widget.onAnimationComplete;
            if (callback == null) {
              _controller.repeat();
              return;
            }
            _controller.value = 0;
            _controller.forward().whenCompleteOrCancel(callback);
          },
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
