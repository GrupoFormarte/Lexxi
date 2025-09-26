import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';
import 'package:lexxi/src/global/widgets/medalla_rive.dart';
import 'package:sizer/sizer.dart';


class Subject extends StatefulWidget {
  const Subject(
      {super.key,
      required this.text,
      required this.onClick,
      required this.animation, required this.tag, this.previeColor, this.color});

  final String text, animation, tag;
   final Color? previeColor;
   final Color? color;

  final Function() onClick;

  @override
  State<Subject> createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {


  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 100.w,
        height: 127,
        child: Stack(
          children: [
            Positioned(
              left: 100,
              top: 20,
              child: Container(
                width: 100.w,
                height: 100,
                padding: const EdgeInsets.only(left: 100),
                decoration: BoxDecoration(
                  gradient: context.darkmode ? AppColors.linearGradientDefault : AppColors.linealGGrey,
                  borderRadius: BorderRadius.circular(96.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 145,
                      child: Text(
                        widget.text,
                        textAlign: TextAlign.start,
                        style: context.textTheme.titleLarge!.copyWith(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 50,
              child: SizedBox(
                width: 127,
                height: 127,
                child: Hero(
                  tag: widget.tag,
                  child: MyRiveAnimation(color: widget.color,previeColor: widget.previeColor,level: widget.animation),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
