import 'dart:math';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lexxi/aplication/item_dynamic/item_dynamic_use_case.dart';
import 'package:lexxi/aplication/student/student_service.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';
import 'package:lexxi/domain/student/model/student.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/widgets/body_custom.dart';
import 'package:lexxi/src/global/widgets/circles_level.dart';
import 'package:lexxi/src/global/widgets/logo.dart';
import 'package:lexxi/src/global/widgets/style_arrow.dart';
import 'package:lexxi/src/providers/grado_provider.dart';
import 'package:lexxi/src/routes/routes_import.gr.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';

@RoutePage() // Add this annotation to your routable pages
class Simulacrum extends StatefulWidget {
  final String grado;
  const Simulacrum({super.key, required this.grado});

  @override
  State<Simulacrum> createState() => _SimulacrumState();
}

class _SimulacrumState extends State<Simulacrum> with TickerProviderStateMixin {
  late RiveAnimationController<dynamic> _controller;
  ValueNotifier<List<Item>> grados = ValueNotifier([]);
  Item? gradoSelected;
  late Animation<double> _animationDialog;

  late AnimationController _controllerDialog;

  final itemUseCase = getIt.get<ItemDynamicUseCase>();
  final StudentService _studentService = getIt.get<StudentService>();
  Student? student;
  ValueNotifier<Grado?> historyGrado = ValueNotifier(null);
  ValueNotifier<Map<String, dynamic>> positionToStudentCount = ValueNotifier(
    {},
  );
  @override
  void initState() {
    // _controller.
    super.initState();
    _controller = SimpleAnimation('nivel_3');
    _controllerDialog = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animationDialog = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controllerDialog, curve: Curves.easeInOut),
    );

    _initDialogAnimation();
    loadData();
  }

  loadData() async {
    student = await _studentService.getInfo();

    historyGrado.value = student?.grados!.first;
    final allItems = await itemUseCase.getAllItems(collection: "Grados");
    final filtered = allItems
        .where((item) => item.childrents.isNotEmpty)
        .toList();
    grados.value = filtered;
    final g = student?.grados!.first.grado;
    positionToStudentCount.value = await _studentService.getPosition(g!);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: historyGrado,
      builder: (context, historysData, _) {
        return CustomBody(
          expandedHeight: 15.h,
          appBar: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [BackButton(), Logo()],
          ),
          header: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (historysData != null)
                bestWorstTimesCard(historysData.obtenerMejorYPeorTiempo()),
            ],
          ),
          onhasScrolled: (bool hasScrolled) {
            // print(hasScrolled);
          },
          title: 'Entrenamientos',
          body: SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                // height: 500,
                child: Column(
                  children: [
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: grados,
                          builder: (context, value, child) {
                            return _gradesProgram(value);
                          },
                        ),
                        const SizedBox(height: 50),
                        if (historysData != null) ...[
                          ValueListenableBuilder(
                            valueListenable: positionToStudentCount,
                            builder: (context, data, _) {
                              if (data.isEmpty) {
                                return const SizedBox();
                              }
                              return rankingCard(
                                historysData.calcularRankingResumen(
                                  totalUsuarios: data['n_estudiantes'],
                                ),
                              );
                            },
                          ),
                          trainingProgressCard(
                            historysData.obtenerResumenUltimaSesion(),
                          ),
                        ],
                        SizedBox(width: 100.w, height: 70),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _gradesProgram(List<Item> items) {
    final PageController controller = PageController(viewportFraction: 0.7);
    //  student.grados
    return SizedBox(
      width: 100.w,
      height: 400,
      child: PageView.builder(
        controller: controller,
        itemCount: items.length, // Aquí puedes reemplazar por tu lista real
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              showTrainingModeDialog(grado: items[index]);
            },
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                double value = 1.0;
                if (controller.position.haveDimensions) {
                  value = controller.page! - index;
                  value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                }
                return Center(
                  child: Transform.scale(
                    scale: Curves.easeOut.transform(value),
                    child: child,
                  ),
                );
              },
              child: _gradeCard(items[index]), // el contenido visual
            ),
          );
        },
        onPageChanged: (index) {
          getGrado(items[index]);
        },
      ),
    );
  }

  Widget rankingCard(RankingResumen calcularRankingResumen) {
    final arrowIcon = calcularRankingResumen.tendencia == 'Igual'
        ? Icons.arrow_forward
        : (calcularRankingResumen.tendencia == 'Bajó'
              ? Icons.arrow_downward
              : Icons.arrow_upward);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "# Tu posición en el ranking:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${calcularRankingResumen.posicionActual} de ${calcularRankingResumen.totalUsuarios}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (calcularRankingResumen.tendencia != 'Sin datos')
                    Icon(arrowIcon, color: Colors.tealAccent, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    " ${calcularRankingResumen.tendencia} posiciones esta semana",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget trainingSessionInfo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.fiber_manual_record, size: 8, color: Colors.tealAccent),
            SizedBox(width: 6),
            Text(
              "Modo: Tiempo (Difícil)",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.bubble_chart_outlined,
              size: 18,
              color: Colors.tealAccent,
            ),
            SizedBox(width: 6),
            Text("Preguntas: 20", style: TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.access_time_filled, size: 18, color: Colors.tealAccent),
            SizedBox(width: 6),
            Text("Tiempo total: 60 min", style: TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }

  _initDialogAnimation() {
    Future.delayed(const Duration(seconds: 1), () {
      _controllerDialog.forward();
    });
    Future.delayed(const Duration(seconds: 4), () {
      _controllerDialog.reverse();
    });

    // setState(() {
    //   _isClicked = true;
    //   _controllerDialog.forward();
    // });
    // Future.delayed(const Duration(seconds: 3), () {
    //   setState(() {
    //     _isClicked = false;
    //   });
    // });
  }

  Widget bestWorstTimesCard(Map<String, String> obtenerMejorYPeorTiempo) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white10, // Fondo oscuro traslúcido
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Mejor tiempo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tu mejor tiempo",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                obtenerMejorYPeorTiempo["mejor"] ?? '',
                style: const TextStyle(
                  color: ColorPalette.secondary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Peor tiempo
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Tu peor tiempo",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                obtenerMejorYPeorTiempo["peor"] ?? '',
                style: const TextStyle(
                  color: ColorPalette.secondary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget inProgressStatus(Item grado) {
    return SizedBox(
      height: 250,
      width: 100.w,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // Tarjeta de estado
          Positioned(
            // bottom: -20,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.2.h),
                constraints: BoxConstraints(minWidth: 60.w, maxWidth: 80.w),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: ColorPalette.secondary),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Iniciar Entrenamiento ${grado.shortName}",
                  textAlign: TextAlign.center,
                  // maxLines:2,
                  style: TextStyle(
                    color: ColorPalette.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 20,
            child: SizedBox(
              width: 70,
              height: 70,
              child: GestureDetector(
                onTap: () {
                  // context.router.push(QuizRoute(grado: widget.grado));
                },
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/logo_lexxi.png'),
                          fit: BoxFit.contain,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.3,
                            ), // sombra semi-transparente
                            blurRadius: 10, // qué tan difusa es la sombra
                            spreadRadius: 2, // qué tanto se expande
                            offset: const Offset(
                              0,
                              4,
                            ), // posición de la sombra (x, y)
                          ),
                        ],
                        borderRadius: BorderRadius.circular(
                          8,
                        ), // opcional: esquinas redondeadas
                      ),
                    ),
                    // CustomPaint(
                    //   size: const Size(120, 120),
                    //   painter: PentagonPainter(color: AppColors.blueDark),
                    // ),
                    // MedalGradient(controller: [_controller]),
                    // _alert()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget trainingProgressCard(ResumenEntrenamiento obtenerResumenUltimaSesion) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Progreso del entrenamiento',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Última sesión: ${obtenerResumenUltimaSesion.preguntas} preguntas',
                style: const TextStyle(color: Colors.white),
              ),

              Text(
                'Resultado: ${obtenerResumenUltimaSesion.resultado}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.white.withOpacity(0.1),
              //     foregroundColor: Colors.white,
              //     elevation: 0,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   onPressed: () {},
              //   child: const Text('Ver historial'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void showTrainingModeDialog({required Item grado}) {
    gradoSelected = grado;
    final gradoProvider = Provider.of<GradoProvider>(context, listen: false);
    gradoProvider.idGrado = grado.id!;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text.rich(
                      TextSpan(
                        text: '¿Cómo deseas entrenar hoy?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        showQuestionCountDialog(grado: grado);
                        // Acción fácil
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb, color: Colors.tealAccent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rétate",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.tealAccent,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Puedes elegir el número de preguntas que deseas responder por área manejando tu tiempo.",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Entrenamiento Difícil
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        context.router.push(
                          LoadsQuestionsRoute(
                            typeExam: "Rétate",
                            grado: grado, // Tipo Item?
                          ),
                        );
                      },
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.flash_on, color: Colors.blueAccent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Supérate",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Tienes un tiempo limitado para responder cada  pregunta.",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Cancelar
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showQuestionCountDialog({required Item grado}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return _blurredDialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text.rich(
                TextSpan(
                  text: '¿Cuántas preguntas deseas por área?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [10, 30, 60].map((count) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      context.router.push(
                        LoadsQuestionsRoute(
                          typeExam: "Supérate",
                          grado: grado, // Tipo Item?
                          preguntas: count, // Tipo int?
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent.withOpacity(0.1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "$count",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _blurredDialog({required Widget child}) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    );
  }

  Widget _buttonContent(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void getGrado(Item grado) async {
    // student!.grados!.firstWhere((element) => element.grado == grado.value);

    for (var g in student!.grados!) {
      if (g.idGrado == grado.id) {
        // _grado = g;
        positionToStudentCount.value = await _studentService.getPosition(
          g.grado!,
        );

        historyGrado.value = g;

        break;
      }
    }
  }

  Widget _gradeCard(Item grado) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          top: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 300,
            // height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: ValueListenableBuilder(
                    valueListenable: positionToStudentCount,
                    builder: (context, pTs, _) {
                      return CirclesLevel(
                        title: 'Tu posición',
                        puntaje: "${pTs['posicion'] ?? 0}",
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(bottom: -50, child: inProgressStatus(grado)),
      ],
    );
  }

  Widget _alert() {
    return AnimatedBuilder(
      animation: _animationDialog,
      builder: (context, _) {
        return Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Transform.scale(
                scale: _animationDialog.value,
                child: const StyleArrow(title: 'Toca el medallón para iniciar'),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PentagonPainter extends CustomPainter {
  final Color color;
  PentagonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;

    final Path path = Path();
    final double w = size.width;
    final double h = size.height;

    final double centerX = w / 2;
    final double centerY = h / 2;
    final double radius = w / 2;

    for (int i = 0; i < 5; i++) {
      double angle = (72 * i - 90) * 3.14159265 / 180;
      double x = centerX + radius * cos(angle);
      double y = centerY + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PentagonBorderPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;

  PentagonBorderPainter({required this.borderColor, required this.borderWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final Path path = Path();
    final double w = size.width;
    final double h = size.height;
    final double centerX = w / 2;
    final double centerY = h / 2;
    final double radius = w / 2;

    for (int i = 0; i < 5; i++) {
      double angle = (72 * i - 90) * 3.14159265 / 180;
      double x = centerX + radius * cos(angle);
      double y = centerY + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
  // const Stack(
                              //   alignment: Alignment.center,
                              //   children: [
                              //     Padding(
                              //       padding: EdgeInsets.all(30.0),
                              //       child: SizedBox(
                              //         width: 190,
                              //         height: 190,
                              //         child: CircularProgressIndicator(
                              //           value: 0.45,
                              //           strokeWidth: 10,
                              //           backgroundColor: AppColors.blueDark,
                              //           valueColor: AlwaysStoppedAnimation<Color>(
                              //               Colors.tealAccent),
                              //         ),
                              //       ),
                              //     ),
                              //     Column(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         Text(
                              //           "15:28",
                              //           style: TextStyle(
                              //               fontSize: 36, fontWeight: FontWeight.bold),
                              //         ),
                              //         // SizedBox(height: 4),
                              //         // Text("oh min",
                              //         //     style: TextStyle(color: Colors.grey)),
                              //       ],
                              //     ),
                              //   ],
                              // ),