import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lexxi/domain/componente_educativo/model/componente_educativo.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';
import 'package:lexxi/src/global/utils/change_colors.dart';
import 'package:lexxi/src/global/widgets/gradient_button.dart';
import 'package:lexxi/src/pages/quiz/widgets/quill_read.dart';
import 'package:lexxi/utils/html_content_parser.dart';
import 'package:sizer/sizer.dart';

class Questions extends StatefulWidget {
  final Function(ComponenteEducativo) answerSelected;

  final Function(int) indexChange;
  final int index;
  final List<ComponenteEducativo> respuestas;
  const Questions({
    Key? key,
    required this.index,
    required this.indexChange,
    required this.answerSelected,
    required this.respuestas,
  }) : super(key: key);

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<String> alphabet =
      List.generate(26, (i) => String.fromCharCode(i + 65));

  final ValueNotifier<int> _selectedIndex = ValueNotifier(-1);
  late ScrollController _scrollController;

  late HtmlContentParser _contentParser;
  List<ComponenteEducativo> respuestasNewOrder = [];

  @override
  void initState() {
    super.initState();
    _contentParser = HtmlContentParser();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scrollController = ScrollController();
    respuestasNewOrder = List.from(widget.respuestas)..shuffle();

    _startAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (timer.tick >= widget.respuestas.length) {
        timer.cancel();
      } else {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C314A).withOpacity(0.76),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      context.router.pop();
                    },
                    child: const Icon(
                      Icons.cancel,
                      size: 40,
                      color: Colors.white,
                    )),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: ListView.builder(
              itemCount: respuestasNewOrder.length,
              controller: _scrollController, // Agrega el ScrollController aquí
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final animation = Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          (index + 1) / respuestasNewOrder.length,
                          1.0,
                          curve: Curves.easeInOut,
                        ),
                      ),
                    );

                    return Opacity(
                      opacity: animation.value,
                      child: Transform.translate(
                        offset: Offset(0, 10.0 * (1.0 - animation.value)),
                        child: child,
                      ),
                    );
                  },
                  child: _item(index),
                );
              },
            ),
          ),
          Expanded(
              flex: 0,
              child: Column(
                children: [
                  GradientButton(
                    text: 'Continuar',
                    onPressed: () {
                      int index = widget.index;
                      final ind = index + 1;
                      widget.indexChange(ind);
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _item(int i) {
    return GestureDetector(
      onTap: () {
        // _scrollToIndex(i);
        widget.answerSelected(respuestasNewOrder[i]);
        // _selectedIndex.value = _selectedIndex.value == i ? -1 : i;
        _selectedIndex.value = i;
      },
      child: ValueListenableBuilder<int>(
          valueListenable: _selectedIndex,
          builder: (context, selectedIndex, child) {
            final controller = respuestasNewOrder[i].toFleather()!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  width: 90.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27.0),
                    // color: AppColors.blueDark,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 100.w,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                            color: whiteToBlack(context),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x29000000),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ]),
                        child: Column(
                          children: [
                            AnimatedContainer(
                              width: selectedIndex == i ? 100.w : 30,
                              height: selectedIndex == i ? 54.0 : 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    selectedIndex == i ? 15.0 : 27),
                                gradient: selectedIndex != i
                                    ? AppColors.linealGGrey
                                    : AppColors.linealGrdientGreen,
                              ),
                              duration: const Duration(milliseconds: 300),
                              child: Center(
                                child: Text(alphabet[i],
                                    style: context.textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 25,
                                            color: selectedIndex == i
                                                ? AppColors.blueDark
                                                : const Color(0xFF3BF4B5))),
                              ),
                            ),
                            Container(
                              width: 76.w,
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                children: [
                                  QuillRead(
                                    controller: controller,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  void _scrollToIndex(int index) {
    _scrollController.animateTo(
      index *
          100.0, // Puedes ajustar este valor según el tamaño de tus elementos
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }
}
