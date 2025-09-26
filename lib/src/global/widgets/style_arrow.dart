import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';
import 'package:lexxi/src/global/utils/change_colors.dart';

class StyleArrow extends StatelessWidget {
  const StyleArrow({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: customStyleArrow(
          color:  blackToWhite(context)),
      child: Container(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 10,
          top: 10,
        ),
        child: Text(
          title,
          style: context.textTheme.titleLarge!.copyWith(
              fontSize: 10,
              color:   context.darkmode ?  AppColors.blueDark: AppColors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class customStyleArrow extends CustomPainter {
  final Color color;

  customStyleArrow({this.color = AppColors.blueDark});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    const double triangleH = 10;
    const double triangleW = 25.0;
    final double width = size.width;
    final double height = size.height;

    final Path trianglePath = Path()
      ..moveTo(width / 2 - triangleW / 2, height)
      ..lineTo(width / 2, triangleH + height)
      ..lineTo(width / 2 + triangleW / 2, height)
      ..lineTo(width / 2 - triangleW / 2, height);

    // Agregar sombra al triángulo
    canvas.drawShadow(trianglePath, Colors.black, 3.0, true);

    canvas.drawPath(trianglePath, paint);
    final BorderRadius borderRadius = BorderRadius.circular(50);
    final Rect rect = Rect.fromLTRB(0, 0, width, height);
    final RRect outer = borderRadius.toRRect(rect);

    // Crear un Path a partir del RRect
    final Path rectPath = Path()..addRRect(outer);

    // Agregar sombra al rectángulo
    canvas.drawShadow(rectPath, Colors.black, 3.0, true);

    canvas.drawRRect(outer, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
