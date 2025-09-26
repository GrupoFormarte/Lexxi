import 'package:flutter/material.dart';
import 'package:lexxi/src/global/widgets/medalla_rive.dart';
import 'package:rive/rive.dart';

class MedalGolden extends StatefulWidget {
  const MedalGolden({super.key,  this.onInit});

  final Function(Artboard)? onInit;

  @override
  State<MedalGolden> createState() => _MedalGoldenState();
}

class _MedalGoldenState extends State<MedalGolden> {


  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return const MyRiveAnimation(color: Colors.purple,level: "nivel_3");

    // return Stack(
    //   children: [
    //     SizedBox(
    //         width: 100.w,
    //         height: 100.w,
    //         child: RiveAnimation.asset(
    //           'assets/medalla_formarte.riv',
    //           controllers: [controller],
    //           onInit: onInit,
    //         )),
    //   ],
    // );
  }
}
//MyRiveAnimation
