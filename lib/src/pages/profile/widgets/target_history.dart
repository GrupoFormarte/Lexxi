import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';
import 'package:lexxi/src/global/utils/change_colors.dart';
import 'package:sizer/sizer.dart';

class TargetHistory extends StatelessWidget {
  final bool isRight;
  final double puntaje;
  final String asignatura;
  final String score;
  const TargetHistory(
      {super.key,
      this.isRight = true,
      required this.puntaje,
      required this.asignatura,
      required this.score});

  @override
  Widget build(BuildContext context) {
    return isRight ? _right(context) : _left(context);
  }

  Widget _right(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            width: 100.w,
            height: 150,
            decoration: BoxDecoration(
              gradient: context.darkmode
                  ? AppColors.linearGradientDefault
                  : AppColors.linealGGrey,
              borderRadius: BorderRadius.circular(31.0),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 55.w,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Column(
                            children: [
                              SliderTheme(
                                data: SliderThemeData(
                                  thumbColor: Colors.red,
                                  activeTrackColor: Colors.grey,
                                  inactiveTrackColor: Colors.grey,
                                  trackHeight: 8,
                                  thumbShape: SliderComponentShape.noThumb,
                                  showValueIndicator: ShowValueIndicator.always,

                                  trackShape:
                                      const _GradientRectSliderTrackShape(
                                          gradient:
                                              AppColors.linealGrdientGreen,
                                          darkenInactive: false),
                                  // thumbShape:
                                  //     RoundSliderThumbShape(enabledThumbRadius: 12),
                                ),
                                child: Slider(
                                    value: puntaje,
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                    label: 20.round().toString(),
                                    onChanged: (v) {}),
                              ),
                              Text(
                                asignatura,
                                style: context.textTheme.titleLarge!
                                    .copyWith(fontSize: 20),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          // Positioned(
                          //   left: (40 / 100) *
                          //       (MediaQuery.of(context).size.width -
                          //           16), // Calcula la posición en función del valor del slider y el ancho disponible
                          //   child: Container(
                          //     color: Colors.red,
                          //     child: const Text(
                          //       '80', // Valor seleccionado del slider convertido a texto
                          //       style: TextStyle(
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.w,
                )
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: 40.w,
              height: 150,
              decoration: BoxDecoration(
                gradient: ColorPalette.gradientGrey,
                borderRadius: BorderRadius.circular(31.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(score,
                      style:
                          context.textTheme.titleLarge!.copyWith(fontSize: 17)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _left(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            width: 100.w,
            height: 150,
            decoration: BoxDecoration(
              gradient: context.darkmode
                  ? AppColors.linearGradientDefault
                  : AppColors.linealGGrey,
              borderRadius: BorderRadius.circular(31.0),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 40.w,
                ),
                SizedBox(
                  width: 55.w,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Column(
                            children: [
                              SliderTheme(
                                data: SliderThemeData(
                                  thumbColor: Colors.red,
                                  activeTrackColor: Colors.grey,
                                  inactiveTrackColor: Colors.grey,
                                  trackHeight: 8,
                                  thumbShape: SliderComponentShape.noThumb,
                                  showValueIndicator: ShowValueIndicator.always,

                                  trackShape:
                                      const _GradientRectSliderTrackShape(
                                          gradient:
                                              AppColors.linealGrdientGreen,
                                          darkenInactive: false),
                                  // thumbShape:
                                  //     RoundSliderThumbShape(enabledThumbRadius: 12),
                                ),
                                child: Slider(
                                    value: puntaje,
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                    label: 20.round().toString(),
                                    onChanged: (v) {}),
                              ),
                              Text(
                                asignatura,
                                style: context.textTheme.titleLarge!
                                    .copyWith(fontSize: 20),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            child: Container(
              width: 40.w,
              height: 150,
              decoration: BoxDecoration(
                  // color: AppColors.blueDark,
                  borderRadius: BorderRadius.circular(31.0),
                  gradient: ColorPalette.gradientGrey),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(score,
                      style: context.textTheme.titleLarge!.copyWith(
                          fontSize: 17, color: whiteToBlack(context))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* class CustomTrackShape extends SliderTrackShape {
  final double _disabledThumbGapWidth = 2.0;
  final double _thumbRadius = 12.0;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double thumbGapWidth =
        sliderTheme.trackHeight! * 2 - _disabledThumbGapWidth;
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx + _thumbRadius;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - _thumbRadius * 2;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    Offset? secondaryOffset,
  }) {
    if (sliderTheme.trackHeight == null) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint primaryPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final Paint secondaryPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    context.canvas.drawRRect(
        RRect.fromRectAndRadius(trackRect, const Radius.circular(2.0)),
        secondaryPaint);

    final thumbRadius =
        isEnabled ? _thumbRadius : _thumbRadius - _disabledThumbGapWidth;

    context.canvas.drawCircle(thumbCenter, thumbRadius, primaryPaint);
  }
} */

class _GradientRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const _GradientRectSliderTrackShape({
    this.gradient = const LinearGradient(
      colors: [
        Colors.red,
        Colors.yellow,
      ],
    ),
    this.darkenInactive = true,
  });

  final LinearGradient gradient;
  final bool darkenInactive;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
    Offset? secondaryOffset,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(sliderTheme.trackHeight != null && sliderTheme.trackHeight! > 0);

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final activeGradientRect = Rect.fromLTRB(
      trackRect.left,
      (textDirection == TextDirection.ltr)
          ? trackRect.top - (additionalActiveTrackHeight / 2)
          : trackRect.top,
      thumbCenter.dx,
      (textDirection == TextDirection.ltr)
          ? trackRect.bottom + (additionalActiveTrackHeight / 2)
          : trackRect.bottom,
    );

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = darkenInactive
        ? ColorTween(
            begin: sliderTheme.disabledInactiveTrackColor,
            end: sliderTheme.inactiveTrackColor)
        : activeTrackColorTween;
    final Paint activePaint = Paint()
      ..shader = gradient.createShader(activeGradientRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    Paint leftTrackPaint;
    Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius = Radius.circular(trackRect.height / 2 + 1);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.ltr)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.ltr)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
      ),
      rightTrackPaint,
    );
  }
}
