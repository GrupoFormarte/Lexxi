import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimationRive extends StatefulWidget {
  const AnimationRive({super.key});

  @override
  State<AnimationRive> createState() => _AnimationRiveState();
}

class _AnimationRiveState extends State<AnimationRive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: RiveAnimation.asset(
              'aassets/medalla_formarte.riv',
              artboard: 'artboard',
              animations: const ['nivel_3'],
              onInit: (artboard) {
                _changeRiveColors(artboard, {
                  'nivel_3': Colors.transparent,
                  'llama_4': Colors.red,
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _changeRiveColors(Artboard artboard, Map<String, Color> replacements) {
    final fills = <Fill>{};

    artboard.forEachComponent((component) {
      if (component is Fill) {
        fills.add(component);
      }
    });

    for (final fill in fills) {
      if (replacements.containsKey(fill.name)) {
        fill.paint.color = replacements[fill.name]!;
        final paintMutator = fill.paintMutator;
        if (paintMutator is SolidColor) {
          paintMutator.color = replacements[fill.name]!;
        }
      }
    }
  }
}
