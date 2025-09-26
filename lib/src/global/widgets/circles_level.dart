import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';
import 'package:lexxi/src/global/widgets/style_arrow.dart';
import 'package:sizer/sizer.dart';

class CirclesLevel extends StatefulWidget {
  const CirclesLevel({
    Key? key,
    required this.title,
    required this.puntaje,
  }) : super(key: key);

  final String title;
  final String puntaje;


  @override
  _CirclesLevelState createState() => _CirclesLevelState();
}

class _CirclesLevelState extends State<CirclesLevel>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _animationDialog;
  late AnimationController _controllerDialog;
  bool _isClicked = false;
  bool _dialogShown = false; // Nueva variable para controlar si ya se mostró

  @override
  void initState() {
    super.initState();

    _controllerDialog = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _animationDialog = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controllerDialog, curve: Curves.easeInOut),
    );
    _animation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

   _initDialogAnimation();
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerDialog.dispose();
    super.dispose();
  }

  _initDialogAnimation() {
    if (!_dialogShown) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _dialogShown = true;
          });
          _controllerDialog.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: [
                Transform.scale(
                  scale: _animation.value,
                  child: _circle(
                    Transform.scale(
                      scale: _animation.value,
                      child: _circle(
                        Transform.scale(
                          scale: _animation.value,
                          child: _circle(
                            null,
                            color: const Color.fromARGB(255, 239, 179, 144),
                          ),
                        ),
                        color: const Color.fromARGB(255, 253, 148, 88),
                      ),
                    ),
                  ),
                ),
                if ( _dialogShown)
                  AnimatedBuilder(
                    animation: _animationDialog,
                    builder: (context, _) {
                      return Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Transform.scale(
                              scale: _animationDialog.value,
                              child: const StyleArrow(
                                title: 'Toca 2 veces para\nir a simulacros',
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                Center(child: contens(context)),
              ],
            );
          },
        );
  }

  Widget _circle(Widget? child, {Color color = const Color(0xFFff6a14)}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
        // gradient: _isBlck() ,
        boxShadow: _isClicked
            ? [
                const BoxShadow(
                  color: Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ]
            : [],
      ),
      child: child,
    );
  }

  Gradient _isBlck() {
    return context.darkmode
        ? (_isClicked ? AppColors.gradientAction : AppColors.linealGrdientGreen)
        : (_isClicked
            ? AppColors.linealGrdientGreen
            : AppColors.linearGradientDefault);
  }

  Widget contens(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.title,
          style: context.textTheme.titleMedium!.copyWith(fontSize: 3.w),
        ),
        Text.rich(
          TextSpan(
            style: context.textTheme.titleLarge,
            children: [
              TextSpan(
                text: widget.puntaje,
                style: context.textTheme.titleLarge!.copyWith(fontSize: 5.w),
              ),
              const TextSpan(
                text: 'pt',
              ),
            ],
          ),
        ),
      ],
    );
  }
}