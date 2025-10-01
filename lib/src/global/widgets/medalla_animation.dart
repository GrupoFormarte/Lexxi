import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';

class MedallaAnimation extends StatefulWidget {
  const MedallaAnimation({super.key});

  @override
  State<MedallaAnimation> createState() => _MedallaAnimationState();
}

class _MedallaAnimationState extends State<MedallaAnimation> {
  // / Controller for playback
  late RiveAnimationController _controller;
  late RiveAnimationController _controller2;

  String start = 'inicio';

  int index = 0;
  // Toggles between play and pause animation states
  void _togglePlay() =>
      setState(() => _controller.isActive = !_controller.isActive);

  /// Tracks if the animation is playing by whether controller is running
  bool get isPlaying => _controller.isActive;

  @override
  void initState() {
    _controller = SimpleAnimation('nivel_0');
    _controller2 = SimpleAnimation('nivel_0');

    // _controller.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 100.w,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(
                          width: 100,
                          height: 100,
                          child: RiveAnimation.asset(
                            'assets/medalla_formarte.riv',
                            controllers: [_controller],
                            // animations:const ['inicio','nivel_1','nivel_2','nivel_3'],
                            // Update the play state when the widget's initialized
                            onInit: (Artboard artboard) {
                              artboard.forEachComponent(
                                (child) {
                                  if (child is Shape) {
                                    if (child.name == "") {
                                      // final shape = child;
                                      // shape.fills.first.paint.color =
                                      //     getRandomColor();
                                    }
                                    index++;
                                  }
                                },
                              );
                            },
                          )),
                      SizedBox(
                          width: 100,
                          height: 100,
                          child: RiveAnimation.asset(
                            'assets/medallon_degradado.riv',
                            controllers: [_controller2],
                            // animations:const ['inicio','nivel_1','nivel_2','nivel_3'],
                            // Update the play state when the widget's initialized
                            onInit: (Artboard artboard) {
                              artboard.forEachComponent(
                                (child) {
                                  if (child is Shape) {
                                    if (child.name == "") {
                                      // final shape = child;
                                      // shape.fills.first.paint.color =
                                      //     getRandomColor();
                                    }
                                    index++;
                                  }
                                },
                              );
                            },
                          )),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              width: 100.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _controller = SimpleAnimation('nivel_0');
                        _controller.isActive;

                        _controller2 = SimpleAnimation('nivel_0');
                        _controller2.isActive;
                        setState(() {});
                      },
                      child: const Text('Inicio')),
                  ElevatedButton(
                      onPressed: () {
                        _controller = SimpleAnimation('nivel_1');
                        _controller.isActive;
                        _controller2 = SimpleAnimation('nivel_1');
                        _controller2.isActive;

                        setState(() {});
                      },
                      child: const Text('nivel_1')),
                  ElevatedButton(
                      onPressed: () {
                        _controller = SimpleAnimation('nivel_2');
                        _controller.isActive;
                        _controller2 = SimpleAnimation('nivel_2');
                        _controller2.isActive;

                        setState(() {});
                      },
                      child: const Text('nivel_2')),
                  ElevatedButton(
                      onPressed: () {
                        _controller = SimpleAnimation('nivel_3');
                        _controller.isActive;
                        _controller2 = SimpleAnimation('nivel_3');
                        _controller2.isActive;

                        setState(() {});
                      },
                      child: const Text('nivel_3')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }
}
