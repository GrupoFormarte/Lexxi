import 'package:flutter/material.dart';

class SignupProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;

  const SignupProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
  });

  static const double _barHeight = 15;
  static const Color _trackColor = Color.fromARGB(160, 255, 255, 255); 
  static const Color _fillColor = Color(0xFFFF8C00); 

  @override
  Widget build(BuildContext context) {
    final progress = ((currentStep + 1) / totalSteps).clamp(0.0, 1.0);

    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth;
              return ClipRRect(
                borderRadius: BorderRadius.circular(_barHeight),
                child: SizedBox(
                  height: _barHeight,
                  width: trackWidth,
                  child: Stack(
                    children: [
                      Container(color: _trackColor),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        height: _barHeight,
                        width: trackWidth * progress,
                        decoration: const BoxDecoration(color: _fillColor),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}