// animated_gradient_container.dart

import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';

class AnimatedGradientContainer extends StatefulWidget {
  final int selectedIndex;
  final int index;
  final String text;

  const AnimatedGradientContainer({
    Key? key,
    required this.selectedIndex,
    required this.index,
    required this.text,
  }) : super(key: key);

  @override
  _AnimatedGradientContainerState createState() =>
      _AnimatedGradientContainerState();
}

class _AnimatedGradientContainerState extends State<AnimatedGradientContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<LinearGradient> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = _controller.drive(
      Tween<LinearGradient>(
        begin: AppColors.linealGrdientGreen,
        end: AppColors.linealGGrey,
      ),
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27.0),
        gradient: widget.selectedIndex != widget.index
            ? AppColors.linealGGrey
            : AppColors.linealGrdientGreen,
      ),
      child: Center(
        child: Text(
          widget.text,
          style: const TextStyle(color: Color(0xFF3BF4B5)),
        ),
      ),
    );
  }
}
