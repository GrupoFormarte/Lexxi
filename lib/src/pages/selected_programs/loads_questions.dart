import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lexxi/aplication/item_dynamic/item_dynamic_use_case.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/providers/data_user_provider.dart';
import 'package:lexxi/src/routes/routes_import.gr.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class LoadsQuestions extends StatefulWidget {
  final Item? grado;
  final int? preguntas;
  final String? typeExam;
  const LoadsQuestions({super.key, this.grado, this.preguntas, this.typeExam});
  @override
  State<LoadsQuestions> createState() => _LoadsQuestionsState();
}

class _LoadsQuestionsState extends State<LoadsQuestions>
    with TickerProviderStateMixin {
  late RiveAnimationController controller1;
  late RiveAnimationController controller2;
  late RiveAnimationController controller3;
  late RiveAnimationController controller4;

  late AnimationController _oscillationController;
  late Animation<Offset> _oscillationAnimation;

  late AnimationController _countdownController; // Controlador para el contador
  late Animation<double> _scaleAnimation; // Animación de escala

  final itemUseCase = getIt.get<ItemDynamicUseCase>();
  List<String> list = [];
  bool isDataLoaded =
      false; // Bandera para saber si los datos han sido cargados

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores de animaciones Rive
    controller1 = SimpleAnimation('nivel_0');
    controller2 = SimpleAnimation('nivel_1');
    controller3 = SimpleAnimation('nivel_2');
    controller4 = SimpleAnimation('nivel_3');

    // Configuración del controlador para la animación de oscilación
    _oscillationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Duración del ciclo de oscilación
    )..repeat(reverse: true); // Hacer que oscile de un lado al otro
    _oscillationAnimation = Tween<Offset>(
      begin: const Offset(0, 0), // Posición inicial
      end: const Offset(0.0, 0.02), // Ligeramente hacia abajo
    ).animate(CurvedAnimation(
      parent: _oscillationController,
      curve: Curves.easeInOut, // Movimiento suave
    ));
    // Inicializar el controlador del contador
    _countdownController = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 5), // Duración del contador (3 segundos)
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _countdownController,
        curve: Curves.easeInOut, // Suavizar la escala
      ),
    );
    // Cargar los datos y comenzar el contador al finalizar la carga
    loadData();
  }

  void loadData() async {
    String programaName = '', idPrograma = '';
    if (widget.grado != null) {
      list = await itemUseCase.getSimulacro(
          grado: widget.grado!.value!, cantidad: widget.preguntas ?? 0);
      programaName = widget.grado!.value!;
      idPrograma = widget.grado!.id!;
    } else {
      final user = context.read<DataUserProvider>().userViewModel;
      list = await itemUseCase.getSimulacro(
          grado: user.value.grado![0].programName!, cantidad: 2);
      programaName = user.value.grado![0].programName!;
      idPrograma = user.value.grado![0].id!;
    }
    setState(() {
      isDataLoaded = true;
    });
    _countdownController.forward().whenComplete(() {
      context.router.push(QuizRoute(
        asignatura: '',
        grado: programaName,
        idGrado: idPrograma,
        level: "nivel_0",
        preguntasIds: list,
        typeExam: widget.typeExam,
        nPreguntas: widget.preguntas,
        needTime: widget.preguntas != null ? false : true,
      ));
    });
  }

  @override
  void dispose() {
    // Detener y limpiar los controladores cuando el widget se destruya
    _oscillationController.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.blueDark, // Fondo oscuro
        ),
        child: Stack(
          children: [
            // Antorchas animadas

            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100.w,
                  height: 50,
                ),
                // SizedBox(
                //   width: 100,
                //   child: MedalGradient(
                //     controller: [
                //       controller1,
                //       controller2,
                //       controller3,
                //       controller4
                //     ],
                //   ),
                // ),
                // Container(
                //   width: 120,
                //   height: 50,
                //   decoration: const BoxDecoration(
                //     image: DecorationImage(
                //       image: AssetImage('assets/lexxi.png'),
                //       fit: BoxFit.contain,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),
                if (isDataLoaded)
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: TweenAnimationBuilder(
                      tween: Tween(begin: 5.0, end: 0.0),
                      duration: const Duration(seconds: 5),
                      builder: (context, value, child) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: ColorPalette.secondary,
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 20),
                // const Text(
                //   'Por dónde Empezamos?',
                //   style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget para la antorcha con animación de oscilación
  Widget _oscillatingAntorcha({
    double width = 100,
    double height = 250,
    double opacity = 1,
    double angle = 0.0,
  }) {
    return SlideTransition(
      position: _oscillationAnimation, // Animación de oscilación
      child: Transform.rotate(
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
      ),
    );
  }
}
