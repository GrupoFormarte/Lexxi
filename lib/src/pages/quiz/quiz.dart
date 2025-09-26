import 'package:auto_route/auto_route.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lexxi/aplication/auth/service/auth_service.dart';
import 'package:lexxi/aplication/detail_preguntas/detail_pregunta_use_case.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:lexxi/domain/componente_educativo/model/componente_educativo.dart';
import 'package:lexxi/domain/detalle_pregunta/model/pregunta.dart';
import 'package:lexxi/domain/quiz/model/result_quiz_model.dart';
import 'package:lexxi/domain/student/model/student.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';
import 'package:lexxi/src/global/utils/change_colors.dart';
import 'package:lexxi/src/global/widgets/custom_popup.dart';
import 'package:lexxi/src/global/widgets/flat_color_button.dart';
import 'package:lexxi/src/global/widgets/gradient_button.dart';
import 'package:lexxi/src/global/widgets/medalla_rive.dart';
import 'package:lexxi/src/pages/quiz/widgets/dual_time_display.dart';
import 'package:lexxi/src/pages/quiz/widgets/questions.dart';
import 'package:lexxi/src/pages/quiz/widgets/quill_read.dart';
import 'package:lexxi/src/providers/resumen_quiz_provider.dart';
import 'package:lexxi/src/routes/routes_import.gr.dart';
import 'package:lexxi/utils/whatsapp.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class Quiz extends StatefulWidget {
  final String? grado;
  final String? idGrado;
  final String? asignatura;
  final List<String> preguntasIds;
  final String level;
  final Student? student;
  final String? typeExam;
  final bool? needTime;
  final int? nPreguntas;

  const Quiz({
    Key? key,
    this.grado,
    this.asignatura,
    required this.preguntasIds,
    this.student,
    this.needTime,
    required this.level,
    this.typeExam,
    this.idGrado,
    this.nPreguntas,
  }) : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> with SingleTickerProviderStateMixin {
  late RiveAnimationController<dynamic> _controller;
  late ScrollController _scrollController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _scaleAnimationInverted;
  int index = 0;
  double containerHeight = 60;
  bool showMenu = false;
  String asignatura = "";
  List<Respuesta> misRespuesta = [];
  Map<String, Style> style = {};
  final ValueNotifier<bool> _valueNotifierLoading = ValueNotifier(true);
  List<DetallePregunta> preguntas = [];
  int indexPregunta = 0;
  final ValueNotifier<DetallePregunta?> preguntaNotifier = ValueNotifier(null);
  late RiveAnimationController<dynamic> _controllerGreen;
  final DetailPreguntasUseCase detailPreguntas =
      getIt.get<DetailPreguntasUseCase>();
  final AuthService _authService = getIt.get<AuthService>();
  int timePassed = 0;

  User? dataUser;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);
    _controller = SimpleAnimation(widget.level);
    _controllerGreen = OneShotAnimation(widget.level, onStop: () {});
    _cargarData();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.ease,
      ),
    );

    _scaleAnimationInverted = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.ease,
      ),
    );

    // Simulación de carga
    Future.delayed(const Duration(seconds: 3), () async {
      _valueNotifierLoading.value = false;
    });
  }

  Future<void> _cargarData() async {
    try {
      dataUser = await _authService.getUserLocal();
      if (widget.preguntasIds.isNotEmpty) {
        final primeraPreguntaId = widget.preguntasIds.first;
        final primeraPregunta =
            await detailPreguntas.obtenerPreguntaPorId(primeraPreguntaId);
        preguntaNotifier.value = primeraPregunta;
        indexPregunta = 1;
        asignatura = primeraPregunta.asignatura!;
      } else {
        _showError('No hay preguntas disponibles.');
      }
    } catch (e, stackTrace) {
      _showError('Ocurrió un error al cargar la primera pregunta.');
    }
  }

  Future<void> nextQuestion() async {
    if (indexPregunta < widget.preguntasIds.length) {
      try {
        final preguntaId = widget.preguntasIds[indexPregunta];
        final pregunta = await detailPreguntas.obtenerPreguntaPorId(preguntaId);
        preguntaNotifier.value = pregunta;

        asignatura = pregunta.asignatura!;
        indexPregunta++;
      } catch (e, stackTrace) {
        _showError('Ocurrió un error al cargar la siguiente pregunta.');
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _controller.dispose();
    _controllerGreen.dispose();
    _scaleController.dispose();
    _valueNotifierLoading.dispose();
    preguntaNotifier.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!showMenu) {
        setState(() {
          containerHeight = 100;
          showMenu = true;
          _scaleController.forward();
        });
      }
    }
  }

  Future<bool> _alert(
      {String description =
          "¿Estás seguro de que quieres dejar la prueba?"}) async {
    bool rr = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(
          title: 'Confirmación',
          message: description,
          actions: [
            GradientButton(
              w: 90,
              text: 'Sí',
              m: 5,
              onPressed: () {
                rr = true;
                // final previousRouteName = context.router.stack.length > 1
                //     ? context.router.stack[context.router.stack.length - 2].name
                //     : null;

                // if (dataUser!.grado != null&&previousRouteName=='LoadsQuestionsRoute') {

                // }

                // print(previousRouteName);
                if (dataUser!.grado != null) {
                  // context.router.popForced();
                  AutoRouter.of(context).replaceAll([
                    const SplashRoute(),
                  ]);
                  return;
                }

                context.router.navigateNamed('/all_programs');
              },
            ),
            GradientButton(
              w: 90,
              text: 'No',
              m: 5,
              onPressed: () {
                rr = false;
                context.router.pop();
              },
            )
          ],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(description, style: context.textTheme.titleLarge),
              ),
            ],
          ),
        );
      },
    );
    return rr;
  }

  void _showQuestionsDialog(DetallePregunta question,
      {required List<ComponenteEducativo> respuestas}) {
    Map<String, dynamic> answerSelected = {
      "idAsignatura": question.id,
      "asignatura": question.area,
      "respuesta": null
    };
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Questions(
          index: index,
          respuestas: respuestas,
          answerSelected: (value) {
            final resp = question.respuestaCorrecta != null
                ? question.respuestaCorrecta == value.id
                : respuestas.first.id == value.id;
            answerSelected["respuesta"] = resp;
            answerSelected["idPregunta"] = question.id;
          },
          indexChange: (value) async {
            if (answerSelected["respuesta"] == null) {
              final resp =
                  await _alert(description: '¿Deseas continuar sin contestar?');
              if (!resp) return;
            }
            preguntaNotifier.value = null;
            final resumenQuiz = context.read<ResumenQuizProvider>();
            misRespuesta.add(Respuesta.fromJson(answerSelected));
            final resultQuizModel = ResultQuizModel();
            resultQuizModel.respuestas = misRespuesta;
            resumenQuiz.resultQuizModel = resultQuizModel;
            context.router.maybePop();
            if (widget.preguntasIds.length == indexPregunta) {
              context.router.push(ResultViewRoute(
                  typeExam: widget.typeExam,
                  grado: widget.grado,
                  idGrado: widget.idGrado,
                  nPreguntas: widget.nPreguntas,
                  timePassed: timePassed,
                  isSimulacro: (widget.grado == null)));
            } else {
              await nextQuestion();
            }
          },
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = (widget.needTime != null && widget.needTime!)
        ? 100.h - 190
        : 100.h - 150;
    return WillPopScope(
      onWillPop: _alert,
      child: Scaffold(
        body: SizedBox(
          width: 100.w,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: whiteToBlack(context),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(21.0),
                      topRight: Radius.circular(21.0),
                    ),
                  ),
                  child: ValueListenableBuilder<DetallePregunta?>(
                    valueListenable: preguntaNotifier,
                    builder: (BuildContext context, value, _) {
                      FleatherController? preguntaController;
                      List<ComponenteEducativo> respuestas = [];
                      if (value != null) {
                        preguntaController =
                            value.preguntaComponent!.toFleather();
                        respuestas = value.respuestasComponete;
                      }
                      return value != null
                          ? Stack(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          BackButton(
                                            onPressed: () async {
                                              final shouldExit = await _alert();
                                              if (shouldExit) {
                                                context.router.pop();
                                              }
                                            },
                                          ),
                                          Text(
                                            value.area!,
                                            style: context.textTheme.titleLarge
                                                ?.copyWith(
                                              color: blackToWhite(context),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Hero(
                                              tag: widget.asignatura ?? '',
                                              child: const MyRiveAnimation(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 20),
                                        child: Column(
                                          children: [
                                            if (widget.needTime != null &&
                                                widget.needTime!)
                                              DualTimerDisplayBlurred(
                                                  baseTimeFormatted: "02:25",
                                                  index: 1,
                                                  onTick: (timeInt) {
                                                    timePassed += timeInt;
                                                  }),
                                            SizedBox(
                                              // color: Colors.red,
                                              height: height,
                                              child: ListView(
                                                children: [
                                                  QuillRead(
                                                    key: ValueKey<int>(
                                                        indexPregunta),
                                                    controller:
                                                        preguntaController!,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FlatColorButton(
                                        color: AppColors.blueDark,
                                        text: const Row(
                                          children: [
                                            Text(
                                              "Ver respuestas",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_up,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          for (var i in respuestas) {
                                            // Verifica si el primer elemento ya es un salto de línea
                                            final first =
                                                i.componente.isNotEmpty
                                                    ? i.componente.first
                                                    : null;

                                            if (first == null ||
                                                first['insert'] != ' \n') {
                                              i.componente = [
                                                {"insert": " \n"},
                                                ...i.componente,
                                              ];
                                            }
                                          }
                                          _showQuestionsDialog(
                                            value,
                                            respuestas: respuestas,
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 20),
                                      GestureDetector(
                                        onTap: () {
                                          final message =
                                              'La pregunta con el código:  ${value.cod}.\n'
                                              'Detalles: (Escribe aquí el problema que tienes con esta pregunta) ';
                                          launchWhatsAppUri(
                                              '+573183491375', message);
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.blue[200],
                                          child: const Icon(
                                            Icons.help_outline,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : _buildLoadingIndicator();
                    },
                  ),
                ),
              ),
              if (showMenu)
                Positioned(
                  top: 0,
                  right: 0,
                  child: _buildMenu(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 100.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.inkDrop(
            color: ColorPalette.secondary,
            size: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return ScaleTransition(
      scale: _scaleAnimationInverted,
      child: Container(
        height: 100,
        width: 200,
        color: Colors.grey.withOpacity(0.7),
        child: Center(
          child: Text(
            'Menú',
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
        ),
      ),
    );
  }
}
