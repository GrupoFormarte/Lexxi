// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:lexxi/src/global/colors_custom.dart';
// import 'package:lexxi/src/global/extensions/build_context_ext.dart';
// import 'package:lexxi/src/global/widgets/body_custom.dart';
// import 'package:lexxi/src/global/widgets/circles_level.dart';
// import 'package:lexxi/src/global/widgets/logo.dart';
// import 'package:lexxi/src/global/widgets/medal_gradient.dart';
// import 'package:lexxi/src/global/widgets/style_arrow.dart';
// import 'package:rive/rive.dart';
// import 'package:sizer/sizer.dart';

// @RoutePage() // Add this annotation to your routable pages

// class Simulacrum extends StatefulWidget {
//   final String grado;
//   const Simulacrum({super.key, required this.grado});

//   @override
//   State<Simulacrum> createState() => _SimulacrumState();
// }

// class _SimulacrumState extends State<Simulacrum> with TickerProviderStateMixin {
//   late RiveAnimationController<dynamic> _controller;

//   late Animation<double> _animationDialog;

//   late AnimationController _controllerDialog;

//   @override
//   void initState() {
//     // _controller.
//     super.initState();
//     _controller = SimpleAnimation('nivel_3');
//     _controllerDialog = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );

//     _animationDialog = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _controllerDialog, curve: Curves.easeInOut),
//     );

//     _initDialogAnimation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomBody(
//         appBar: const Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             BackButton(), Logo(),
//             // GestureDetector(
//             //   onTap: () {
//             //     context.router.pushNamed('/profile');
//             //   },
//             //   child: CircleAvatar(
//             //     backgroundColor: AppColors.blueDark,
//             //     child: _inconUser(),
//             //   ),
//             // )
//           ],
//         ),
//         header: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//                 width: 45.w,
//                 height: 45.w,
//                 child: const CirclesLevel(
//                   title: 'Tu puntaje',
//                   puntaje: '0',
//                 )),
//           ],
//         ),
//         title: 'Entrenamientos',
//         body: SliverFillRemaining(
//           child: SizedBox(
//             height: 500,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 SizedBox(
//                   width: 180,
//                   height: 180,
//                   child: GestureDetector(
//                       onTap: () {
//                         // context.router.push(QuizRoute(grado: widget.grado));
//                       },
//                       child: Stack(
//                         children: [
//                           MedalGradient(controller: [_controller]),
//                           _alert()
//                         ],
//                       )),
//                 ),
//                 Stack(
//                   children: [
//                     Container(
//                       width: 350,
//                       height: 89,
//                       padding: const EdgeInsets.all(15),
//                       decoration: BoxDecoration(
//                         color: const Color(0x6be2e2e2),
//                         borderRadius: BorderRadius.circular(18.0),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Tu meta',
//                             style: context.textTheme.titleLarge!
//                                 .copyWith(fontSize: 20),
//                             softWrap: false,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       right: 0,
//                       child: Container(
//                         width: 128,
//                         height: 89,
//                         decoration: BoxDecoration(
//                           gradient: AppColors.linealGrdientGreen,
//                           borderRadius: BorderRadius.circular(20.0),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               '0 pt',
//                               style: context.textTheme.titleLarge!
//                                   .copyWith(fontSize: 20),
//                               softWrap: false,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   width: 350,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Container(
//                         width: 213,
//                         height: 63,
//                         padding: const EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                           gradient: AppColors.linealGrdientGreen,
//                           borderRadius: BorderRadius.circular(18.0),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Tu puntaje máximo',
//                               style: context.textTheme.titleLarge,
//                               softWrap: false,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         width: 118,
//                         height: 63,
//                         decoration: BoxDecoration(
//                           gradient: AppColors.linealGGrey,
//                           borderRadius: BorderRadius.circular(20.0),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               '0 pt',
//                               style: context.textTheme.titleLarge,
//                               softWrap: false,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: 100.w,
//                   height: 70,
//                 )
//               ],
//             ),
//           ),
//         ));
//   }

//   _initDialogAnimation() {
//     Future.delayed(const Duration(seconds: 1), () {
//       _controllerDialog.forward();
//     });
//     Future.delayed(const Duration(seconds: 4), () {
//       _controllerDialog.reverse();
//     });

//     // setState(() {
//     //   _isClicked = true;
//     //   _controllerDialog.forward();
//     // });
//     // Future.delayed(const Duration(seconds: 3), () {
//     //   setState(() {
//     //     _isClicked = false;
//     //   });
//     // });
//   }

//   Widget _alert() {
//     return AnimatedBuilder(
//       animation: _animationDialog,
//       builder: (context, _) {
//         return Positioned.fill(
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: Container(
//               margin: const EdgeInsets.only(top: 10),
//               child: Transform.scale(
//                 scale: _animationDialog.value,
//                 child: const StyleArrow(
//                   title: 'Toca el medallón para iniciar',
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
