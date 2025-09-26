import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/utils/change_colors.dart';


class SliderRowText extends StatefulWidget {
  final Widget title;
  final bool init;
  final Function(bool) onChanged;

  const SliderRowText({
    Key? key,
    required this.title,
     this.init=false,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SliderRowText> createState() => _SliderRowTextState();
}

class _SliderRowTextState extends State<SliderRowText> {
  bool backgroundColorBlueDark=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    backgroundColorBlueDark=widget.init;

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.title,
          CustomSwitch(
            value: backgroundColorBlueDark,
            onChanged:(v){

               widget.onChanged(v);
               setState(() {
                 backgroundColorBlueDark=v;
               });
            },
            backgroundColorBlueDark: backgroundColorBlueDark,
          ),
        ],
      ),
    );
  }
}
class CustomSwitch extends StatefulWidget {
  final bool? value;
  final bool backgroundColorBlueDark;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color inactiveColor;
  final String activeText;
  final String inactiveText;
  final Color activeTextColor;
  final Color inactiveTextColor;

  const CustomSwitch(
      {Key? key,
      this.value,
      this.onChanged,
      this.activeColor,
      this.inactiveColor = Colors.grey,
      this.activeText = '',
      this.inactiveText = '',
      this.activeTextColor = Colors.white70,
      this.inactiveTextColor = Colors.white70, this.backgroundColorBlueDark=false})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation? _circleAnimation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
            begin: widget.value! ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value! ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController!, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged!(true)
                : widget.onChanged!(false);
          },
          child: Container(
            width: 70.0,
            height: 35.0,
            decoration: BoxDecoration(
              // color: !widget.backgroundColorBlueDark?(context.darkmode?AppColors.white :const Color(0xffcecece)):AppColors.blueDark,
              borderRadius: BorderRadius.circular(20.0),
              gradient: !widget.backgroundColorBlueDark?AppColors.linearGradientDefault:blueDarkToGradienGreen(context)
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 4.0, bottom: 4.0, right: 4.0, left: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _circleAnimation!.value == Alignment.centerRight
                      ? Padding(
                          padding: const EdgeInsets.only(left: 34.0, right: 0),
                          child: Text(
                            widget.activeText,
                            style: TextStyle(
                                color: widget.activeTextColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 16.0),
                          ),
                        )
                      : Container(),
                  Align(
                    alignment: _circleAnimation!.value,
                    child: Container(
                      width: 25.0,
                      height: 25.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          gradient: gradientGreenToBlueDark(context)),
                    ),
                  ),
                  _circleAnimation!.value == Alignment.centerLeft
                      ? Padding(
                          padding: const EdgeInsets.only(left: 0, right: 34.0),
                          child: Text(
                            widget.inactiveText,
                            style: TextStyle(
                                color: widget.inactiveTextColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 16.0),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
