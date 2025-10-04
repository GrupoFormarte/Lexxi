import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:lexxi/aplication/academic_level/academic_level_use_case.dart';
import 'package:lexxi/aplication/auth/service/auth_service.dart';
import 'package:lexxi/aplication/promotion/promotion_use_cause.dart';
import 'package:lexxi/aplication/student/student_service.dart';
import 'package:lexxi/domain/academic_level/model/academic_level.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:lexxi/domain/promotion/model/promotion.dart';
import 'package:lexxi/domain/quiz/model/result_quiz_model.dart';
import 'package:lexxi/domain/student/model/student.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';
import 'package:lexxi/src/global/widgets/circles_level.dart';
import 'package:lexxi/src/global/widgets/gradient_rect_slider_track_shape.dart';
import 'package:lexxi/src/global/widgets/medalla_rive.dart';
import 'package:lexxi/src/global/widgets/promotion_dialog.dart';
import 'package:lexxi/src/global/widgets/video_alert_dialog.dart';
import 'package:lexxi/src/providers/data_user_provider.dart';
import 'package:lexxi/src/providers/grado_provider.dart';
import 'package:lexxi/src/providers/resumen_quiz_provider.dart';
import 'package:lexxi/utils/whatsapp.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';

import '../../global/widgets/flat_color_button.dart';

@RoutePage() // Add this annotation to your routable pages
class ResultView extends StatefulWidget {
  final bool isSimulacro;
  final String? typeExam;
  final String? grado;
  final String? idGrado;
  final int? nPreguntas;
  final int timePassed;

  const ResultView({
    super.key,
    this.isSimulacro = false,
    required this.grado,
    this.typeExam,
    this.idGrado,
    this.timePassed = 0,
    this.nPreguntas,
  });

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView>
    with SingleTickerProviderStateMixin {
  late ConfettiController _controllerCenter;

  ValueNotifier<ResultQuizModel> _resultQuizModel = ValueNotifier(
    ResultQuizModel(),
  );
  ValueNotifier<RiveAnimationController<dynamic>>? _controller;
  // AsignaturaService? _asignaturaService;
  final StudentService _studentService = getIt.get<StudentService>();
  final academyLevels = getIt.get<AcademicLevelUseCase>();
  late double result;
  late Timer _timer;

  late AnimationController _controllerRive;
  late Animation<double> _animation;

  final promotionUseCase = getIt.get<PromotionUseCause>();

  late PromotionModel _promotion;

  int score = 0;
  Student? student;
  dynamic idUser;
  int? permision;
  ValueNotifier<AcademicLevelModel?> academicLevelModel = ValueNotifier(null);

  User? dataUser;

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(
      duration: const Duration(seconds: 10),
    );

    _resultQuizModel = ValueNotifier(
      context.read<ResumenQuizProvider>().resultQuizModel,
    );
    result = _resultQuizModel.value.calcularNotaFinal();

    // _asignaturaService = getIt.get<AsignaturaService>();
    final user = context.read<DataUserProvider>().userViewModel;

    try {
      idUser = user.value.id!;
    } on Exception catch (e) {
      // TODO
    }
    _controller = ValueNotifier(SimpleAnimation('nivel_3'));

    _controllerRive = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true); // Repite la animación (sube y baja)

    _animation = CurvedAnimation(
      parent: _controllerRive,
      curve: Curves.bounceInOut, // Efecto de rebote
    );
    loadData();
  }

  void loadData() async {
    final authService = getIt.get<AuthService>();
    final idGrado = context.read<GradoProvider>().idGrado;
    academicLevelModel.value = await academyLevels.getAcademicLevelById(
      id: idGrado,
    );
    dataUser = await authService.getUserLocal();
    // permision = json.decode(dataUser!.typeUser!);
    student = await _studentService.getInfo();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _controllerCenter.play();
    });
    _promotion = await promotionUseCase.get();
    if (student != null) {
      for (var v in _resultQuizModel.value.respuestas!) {
        final r = v;
        r.idEstudiante = idUser.toString();
        r.idInstituto = dataUser!.institute.toString();
        r.respuesta = r.respuesta ?? false;
        r.dateCreated = DateTime.now().toString();
        r.idGrado = idGrado;

        if (r.respuesta!) {
          for (var i in student!.grados!) {
            if (i.grado == widget.grado) {
              for (var asig in i.asignaturas!) {
                if (asig.asignatura == r.asignatura) {
                  r.idAsignatura = asig.asignaturaId;
                  asig.score++;
                }
              }
              break;
            }
          }
        }
        _studentService.saveStudentResponse(r);
      }
      final r = _resultQuizModel.value.calcularNotaFinal();
      if (widget.idGrado != null) {
        final gradoSelected = student!.grados!.firstWhere(
          (element) => element.idGrado == widget.idGrado,
        );
        gradoSelected.scoreSimulacro = r;
        if (widget.typeExam == "Supérate") {
          gradoSelected.progressHistory.add(
            ProgressHistory(
              date: DateTime.now().toString(),
              duration: "",
              result: r.toString(),
              numberSession: widget.nPreguntas.toString(),
            ),
          );
        }
        if (widget.typeExam == "Rétate") {
          gradoSelected.historyTime.add(
            HistoryTime(
              date: DateTime.now().toString(),
              time: formatDuration(widget.timePassed),
            ),
          );
        }

        for (var i = 0; i < student!.grados!.length; i++) {
          final g = student!.grados![i];
          if (gradoSelected.idGrado == g.idGrado) {
            student!.grados![i] = gradoSelected;
            break;
          }
        }
      }

      _studentService.update(student!);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller!.dispose();
    _controllerCenter.dispose();
    _timer.cancel(); // Cancelar el Timer
    super.dispose();
  }

  void showVideoAlert(String videoUrl, VoidCallback onButtonPressed) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return VideoAlertDialog(
          videoUrl: videoUrl,
          onButtonPressed: onButtonPressed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: 100.w,
            child: ListView(
              shrinkWrap: true,
              children: [
                ValueListenableBuilder(
                  valueListenable: _resultQuizModel,
                  builder: (context, value, _) {
                    // value.respuestas[0].

                    return Stack(
                      children: [
                        // Positioned(
                        //   right: -40,
                        //   top: 70,
                        //   child: _antorcha(
                        //       width: 200,
                        //       height: 550,
                        //       angle: -0.5,
                        //       opacity: 0.7),
                        // ),
                        // Positioned(
                        //   left: -0.5,
                        //   top: 500,
                        //   child: _antorcha(
                        //       width: 80, height: 180, angle: 0.5, opacity: 0.7),
                        // ),
                        _bodyFree(value),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // : const Center(child: CircularProgressIndicator()),
    );
  }

  String formatDuration(int totalSeconds) {
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  Widget _bodyFree(ResultQuizModel value) {
    // ValueListenableBuilder(valueListenable: ,)
    return ValueListenableBuilder(
      valueListenable: academicLevelModel,
      builder: (context, academy, _) {
        if (academy == null) {
          return const Center(child: CircularProgressIndicator());
        }
        // Obtén typeLevel de forma segura
        final typeLevel = academy.compare(value.respuestaCo.toString());
        // Verifica si typeLevel es nulo y maneja ese caso
        if (typeLevel == null) {
          return const Center(child: CircularProgressIndicator());
        }
        // Ahora que estamos seguros de que typeLevel tiene datos, procede a calcular level
        final level = typeLevel.findLevelByPuntaje(
          value.respuestaCo.toString(),
        );
        Color colorLevel = Color(int.parse("0xff${typeLevel.color!}"));
        return Stack(
          children: [
            SizedBox(
              width: 100.w,
              height: 100.h,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(height: 50),
                      ValueListenableBuilder(
                        valueListenable: _controller!,
                        builder: (context, value, _) {
                          return Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: ConfettiWidget(
                                  confettiController: _controllerCenter,
                                  blastDirectionality: BlastDirectionality
                                      .explosive, // don't specify a direction, blast randomly
                                  shouldLoop:
                                      true, // start again as soon as the animation is finished
                                  colors: const [
                                    Colors.green,
                                    Colors.blue,
                                    Colors.pink,
                                    Colors.orange,
                                    Colors.purple,
                                  ], // manually specify the colors to be used
                                  createParticlePath:
                                      drawStar, // define a custom shape/path.
                                ),
                              ),
                              SizedBox(
                                width: 100.w,
                                child: Column(
                                  children: [
                                    // SizedBox(
                                    //   width: 127,
                                    //   height: 127,
                                    //   child: MyRiveAnimation(
                                    //       color: colorLevel,
                                    //       previeColor: colorLevel,
                                    //       level: level!.level!),
                                    // ),

                                    // ScaleTransition(
                                    //   scale: _animation,
                                    //   child: ,
                                    // ),
                                    SizedBox(
                                      width: 127,
                                      height: 127,
                                      child: MyRiveAnimation(
                                        color: colorLevel,
                                        previeColor: colorLevel,
                                        level: level!.level!,
                                      ),
                                    ),
                                    Text(
                                      typeLevel.name!,
                                      style: const TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontSize: 20,
                                        color: Color(0xffffffff),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: false,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Container(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _animatedInfo(
                            value.calcularPorcentajeRespuestasNulas(),
                            "Completado",
                            suffix: '%',
                          ),
                          _animatedInfo(
                            value.respuestas!.length.toString(),
                            "Preguntas",
                          ),
                          _animatedInfo(
                            value.preguntasCorrectas(),
                            "Correctas",
                          ),
                          _animatedInfo(
                            value.preguntasInCorrectas(),
                            "Incorrectas",
                          ),
                        ],
                      ),
                      Container(height: 30),
                      SizedBox(
                        width: 100.w,
                        // height: 400,
                        child: Scrollbar(
                          child: Column(children: _slidersRow(value)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 40),
                        width: 100.w,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // if (dataUser!.grado == null)
                              // SizedBox(
                              //   width: 90,
                              //   child: FlatColorButton(
                              //     color: AppColors.blueDark,
                              //     padding: 0,
                              //     text: const Center(
                              //       child: Icon(Icons.reply_all_rounded,
                              //           color: AppColors.blueDark),
                              //     ),
                              //     onPressed: () {
                              //       context.router.navigateNamed('/');
                              //     },
                              //   ),
                              // ),
                              SizedBox(
                                width: 62.w,
                                child: FlatColorButton(
                                  color: AppColors.blueDark,
                                  text: Text(
                                    "Terminar",
                                    style: context.textTheme.titleLarge!
                                        .copyWith(color: AppColors.blueDark),
                                  ),
                                  onPressed: () {
                                    context.router.pushNamed('/');
                                    // if (student != null) {
                                    //   context.router.pushNamed('/');
                                    //   return;
                                    // }
                                    // showVideoAlert(
                                    //     "assets/videos/Calendario-B2025_1.mp4",
                                   

                                    // showPromotionDialog(
                                    //   context,
                                    //   promotion: _promotion,
                                    //   onClik: () {
                                    //     final message =
                                    //         '¡Hola! Me interesa la promoción: ${_promotion.title}.\n'
                                    //         'Detalles: ${_promotion.description}';
                                    //     launchWhatsAppUri(
                                    //       '+573183491375',
                                    //       message,
                                    //     );
                                   //         context.router.pushNamed('/');  () {});
                                    //   },
                                    // );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _slidersRow(ResultQuizModel value) {
    return value.calcularPromedioRespuestasCorrectasPorAsignatura().map((e) {
      return _sliderRow(e.porcentajeCorrectas, e.nota.toString(), e.asignatura);
    }).toList();
  }

  Widget _sliderRow(double sliderValue, String pt, String label) {
    return SizedBox(
      width: 100.w,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80.w,
                  child: SliderTheme(
                    data: SliderThemeData(
                      thumbColor: Colors.red,
                      activeTrackColor: Colors.grey,
                      inactiveTrackColor: Colors.grey,
                      trackHeight: 8,
                      thumbShape: SliderComponentShape.noThumb,
                      showValueIndicator: ShowValueIndicator.always,
                      trackShape: const GradientRectSliderTrackShape(
                        gradient: AppColors.linealGrdientGreen,
                        darkenInactive: false,
                      ),
                    ),
                    child: Slider(
                      value: sliderValue,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: 20.round().toString(),
                      onChanged: (v) {},
                    ),
                  ),
                ),
                Text(
                  '$pt pt',
                  style: const TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 13,
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 17,
                  color: Color(0xffffffff),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedInfo(
    String targetValueString,
    String label, {
    String suffix = '',
  }) {
    // Convertimos el String a double para la animación
    double targetValue = double.tryParse(targetValueString) ?? 0;

    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: targetValue),
          duration: const Duration(seconds: 2),
          builder: (context, value, child) {
            return Text(
              "${value.toStringAsFixed(0)}$suffix", // Mostramos el número animado con sufijo
              style: const TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 25,
                color: Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 15,
            color: Color(0xffffffff),
          ),
        ),
      ],
    );
  }

  Widget _info(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 25,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 15,
            color: Color(0xffffffff),
          ),
        ),
      ],
    );
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degrees to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(
        halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step),
      );
      path.lineTo(
        halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep),
      );
    }
    path.close();
    return path;
  }

  Widget _antorcha({
    double width = 100,
    double height = 250,
    double opacity = 1,
    double angle = 0.0,
  }) {
    return Transform.rotate(
      angle: angle,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/antorcha.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
