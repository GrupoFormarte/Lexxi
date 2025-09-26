import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';

class GradientSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Gradient gradient;

  const GradientSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.gradient,
  }) : super(key: key);

  @override
  _GradientSwitchState createState() => _GradientSwitchState();
}

class _GradientSwitchState extends State<GradientSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
          widget.onChanged(_value);
        });
      },
      child: Container(
        width: 70.0,
        height: 35.0,
        decoration: BoxDecoration(
          gradient: AppColors.linealGrdientGreen,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: _value ? 35.0 : 0.0,
              child: Container(
                width: 35.0,
                height: 35.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
