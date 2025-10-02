import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lexxi/aplication/academic_level/academic_level_use_case.dart';
import 'package:lexxi/aplication/item_dynamic/item_dynamic_use_case.dart';
import 'package:lexxi/aplication/level/level_use_case.dart';
import 'package:lexxi/aplication/student/student_service.dart';
import 'package:lexxi/domain/academic_level/model/academic_level.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';
import 'package:lexxi/domain/student/model/student.dart';
import 'package:lexxi/infrastructure/auth/data_sources/local_data_source/localstorage_shared.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/widgets/body_custom.dart';
import 'package:lexxi/src/global/widgets/circles_level.dart';
import 'package:lexxi/src/global/widgets/logo.dart';
import 'package:lexxi/src/pages/home/widgets/subject.dart';
import 'package:lexxi/src/providers/data_user_provider.dart';
import 'package:lexxi/src/providers/grado_provider.dart';
import 'package:lexxi/src/routes/routes_import.gr.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

@RoutePage() // Add this annotation to your routable pages
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ValueNotifier<List<Item>> _asignaturasValueNotifier = ValueNotifier([]);
  final item = getIt.get<ItemDynamicUseCase>();
  final StudentService _studentService = getIt.get<StudentService>();
  final _level = getIt.get<LevelUseCase>();
  final ValueNotifier<Student?> _valueNotifierStudent = ValueNotifier(null);
  String? grado;
  AcademicLevelModel? academy;
  ValueNotifier<int> position = ValueNotifier(0);
  Student? student;
  final ValueNotifier<bool> loading = ValueNotifier(true);
  final academyUse = getIt.get<AcademicLevelUseCase>();
  final LocalstorageShared _localstorageShared = LocalstorageShared();

  @override
  void initState() {
    _loadAsignature();
    super.initState();
  }

  Future<void> loadDataUser() async {
    try {
      academy = await academyUse.getAcademicLevelById(
        id: "668d39d63abc9ff60a7979d2",
      );

      final user = context.read<DataUserProvider>().userViewModel;
      final gradosAx =
          user.value.grado; // Listado de grados que se quiere filtrar
      if (gradosAx == null || gradosAx.isEmpty) {
        _showError('No se encontraron grados para el usuario.');
        return;
      }
      final listGrado = await item.getAllItems(collection: "Grados");
      student = await _studentService.getInfo();
      List<Grado> grados = [];
      if (student != null) {
        if (student!.grados == null || student!.grados!.isEmpty) {
          _showError('No se encontraron grados para el estudiante.');
          return;
        }
        // Recorrer los grados en la lista gradosAx
        final Map<String, Grado> gradosMap = {
          for (var g in student!.grados ?? []) g.grado!: g,
        };

        for (var gaux in gradosAx) {
          final grado = gradosMap[gaux.programCode];
          if (grado == null ||
              grado.asignaturas == null ||
              grado.asignaturas!.isEmpty) {
            continue;
          }

          // Ejecutar en paralelo las llamadas a _level.get
          final results = await Future.wait(
            grado.asignaturas!.map((asignatura) {
              return _level.get(
                id: grado.idGrado!,
                score: asignatura.score.toString(),
              );
            }),
          );

          for (int i = 0; i < grado.asignaturas!.length; i++) {
            final asignatura = grado.asignaturas![i];
            final data = results[i];
            if (data == null) continue;

            asignatura.previewColor = data.previousColor;
            asignatura.currentColor = data.currentColor;
            asignatura.level = data.level!;
          }
        }
        _valueNotifierStudent.value = student;
        return;
      }

      final asignaturasList = await Future.wait(
        listGrado.map((g) => asignaturas(g.code!, g.value!)),
      );
      // Si el estudiante no existe, crear uno nuevo
      for (int i = 0; i < listGrado.length; i++) {
        final g = listGrado[i];

        final data = asignaturasList[i];
        List<Asignatura> asigs = [];
        for (var t in data) {
          asigs.add(Asignatura(asignatura: t.value!, asignaturaId: t.id!));
        }
        grados.add(Grado(idGrado: g.id!, grado: g.code!, asignaturas: asigs));
      }

      await _studentService.create(grados);
      // Obtener la información del estudiante después de la creación
      student = await _studentService.getInfo();
      if (student == null) {
        _showError(
          'No se pudo obtener la información del estudiante después de la creación.',
        );
        return;
      }
      for (var grado in student!.grados!) {
        if (grado.asignaturas == null || grado.asignaturas!.isEmpty) continue;
        for (var asignatura in grado.asignaturas!) {
          final data = await _level.get(
            id: grado.idGrado!,
            score: asignatura.score.toString(),
          );
          if (data == null) {
            continue;
          }
          asignatura.previewColor = data.previousColor;
          asignatura.currentColor = data.currentColor;
          asignatura.level = data.level!;
        }
      }

      _valueNotifierStudent.value = student;
    } catch (e, stackTrace) {
      _showError('Ocurrió un error al cargar los datos del usuario.');
    }
  }

  void _showError(String message) {
    // Asegúrate de que el contexto es válido antes de mostrar el Snackbar
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void dispose() {
    _asignaturasValueNotifier.dispose();
    _valueNotifierStudent.dispose();
    loading.dispose();
    super.dispose();
  }

  void _loadAsignature() async {
    await loadDataUser();
    final user = context.read<DataUserProvider>().userViewModel;

    grado = user.value.grado!.first.programCode;
    context.read<GradoProvider>().grado = grado!;
    loading.value = true;

    loading.value = false;
  }

  // Map<>

  Future<List<Item>> asignaturas(String grado, String namelargeGrado) async {
    try {
      final gradoData = await item.searchByField(
        collection: "Grados",
        field: 'code',
        value: grado,
      );

      if (gradoData.isEmpty) {
        return [];
      }

      final childIds = gradoData.first.childrents;

      final asignaturas = await item.getItemsByIdsBulk(
        collection: "get-areas/bulk",
        ids: childIds,
        grado: namelargeGrado,
      );
      if (asignaturas.isEmpty) {
        return [];
      }
      // compararAsignaturasProfundamente(asignaturas, asignaturasAux);
      return asignaturas;
    } on HandshakeException catch (e, stackTrace) {
      return [];
    } catch (e, stackTrace) {
      return [];
    }
  }

  void compararAsignaturasProfundamente(
    List<Item> asignaturas,
    List<Item> asignaturasAux,
  ) {
    final maxLength = max(asignaturas.length, asignaturasAux.length);

    for (int i = 0; i < maxLength; i++) {
      final a = i < asignaturas.length ? asignaturas[i] : null;
      final b = i < asignaturasAux.length ? asignaturasAux[i] : null;
      if (a == null) {
        continue;
      }
      if (b == null) {
        continue;
      }

      // Comparación campo por campo
      final campos = {
        'id': [a.id, b.id],
        'value': [a.value, b.value],
        'code': [a.code, b.code],
        'codeDep': [a.codeDep, b.codeDep],
        'name': [a.name, b.name],
        'shortName': [a.shortName, b.shortName],
        'colecction': [a.colecction, b.colecction],
      };

      bool hayDiferencia = false;

      for (var campo in campos.entries) {
        final campoA = campo.value[0];
        final campoB = campo.value[1];
        if (campoA != campoB) {
          hayDiferencia = true;
        }
      }

      // Comparación profunda de childrents
      final childA = a.childrents;
      final childB = b.childrents;

      if (childA.length != childB.length) {
        hayDiferencia = true;
      }

      final diffA = childA.where((e) => !childB.contains(e)).toList();
      final diffB = childB.where((e) => !childA.contains(e)).toList();

      if (diffA.isNotEmpty) {
        hayDiferencia = true;
      }

      if (diffB.isNotEmpty) {
        hayDiferencia = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // return _body();
    return Stack(
      children: [
        CustomBody(
          appBar: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Logo(),
              ValueListenableBuilder(
                valueListenable: _valueNotifierStudent,
                builder: (context, student, _) {
                  if (student == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GestureDetector(
                    onTap: () {
                      context.router.pushNamed('/profile');
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColors.blueDark,
                      child: _inconUser(),
                    ),
                  );
                },
              ),
            ],
          ),
          header: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 45.w,
                height: 45.w,
                child: ValueListenableBuilder(
                  valueListenable: _valueNotifierStudent,
                  builder: (context, student, _) {
                    if (student == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ValueListenableBuilder(
                      valueListenable: position,
                      builder: (context, score, _) {
                        return GestureDetector(
                          onDoubleTap: () {
                            context.router.push(SimulacrumRoute(grado: grado!));
                          },
                          child: CirclesLevel(
                            title: 'Tu posicion',
                            puntaje: score.toString(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          title: 'Entrenamiento',
          needGrados: true,
          changeGrade: (String v, String namelarge) async {
            try {
              loading.value = true;
              grado = v;
              final positionResult = await _studentService.getPosition(v);
              final a = await asignaturas(v, namelarge);
              _asignaturasValueNotifier.value = a;
              loading.value = false;
              position.value =
                  positionResult["position"] ?? positionResult["posicion"];
            } on Exception catch (e) {
              // TODO
            }
            // setState(() {});
          },
          body: ValueListenableBuilder(
            valueListenable: loading,
            builder: (context, load, _) {
              return ValueListenableBuilder(
                valueListenable: _asignaturasValueNotifier,
                builder: (BuildContext context, value, _) {
                  return !load
                      ? ValueListenableBuilder(
                          valueListenable: _valueNotifierStudent,
                          builder: (context, student, _) {
                            if (student == null) {
                              return const SliverFillRemaining(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final e = value[index];
                                  // Aquí construyes cada uno de tus ítems como antes
                                  // Por ejemplo, usando un ValueListenableBuilder o simplemente listando tus widgets
                                  Level? level;
                                  final score = student.getScoreAsiggnature(
                                    e.id!,
                                    grado!,
                                  );
                                  Color? colorLevel = student.getCurrentColor(
                                    e.id!,
                                    grado!,
                                  );
                                  if (academy != null) {
                                    final typeLevel = academy!.compare(score!);
                                    level = typeLevel!.findLevelByPuntaje(
                                      score,
                                    );
                                    colorLevel = score == '0'
                                        ? student.getCurrentColor(
                                            e.id!,
                                            grado!,
                                            currentColor: false,
                                          )
                                        : Color(
                                            int.parse(
                                              "0xff${typeLevel.color!}",
                                            ),
                                          );
                                  }

                                  return e.getRandomChildren().isNotEmpty
                                      ? Subject(
                                          text: e.value!,
                                          tag: e.value!,
                                          color: colorLevel,
                                          previeColor: colorLevel,
                                          animation:
                                              student.getAsignaturaDetails(
                                                e.id!,
                                                grado!,
                                              ) ??
                                              "nivel_0",
                                          onClick: () async {
                                            final numb =
                                                await _localstorageShared
                                                    .readFromSharedPref(
                                                      'numbesQuestion',
                                                      int,
                                                    );

                                            // Verificar que el widget siga montado antes de usar context
                                            if (!context.mounted) return;

                                            context.router.push(
                                              QuizRoute(
                                                asignatura: e.value,
                                                grado: grado,
                                                level: level!.level!,
                                                student: student,
                                                preguntasIds: e
                                                    .getRandomChildren(n: numb??10),
                                              ),
                                            );
                                          },
                                        )
                                      : const SizedBox();
                                },
                                childCount: value.length, // El número de ítems
                              ),
                            );
                          },
                        )
                      : const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _inconUser() {
    String? photo;
    if (student != null) {
      photo = student!.photo;
    }

    Widget item = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.linealGrdientGreen,
        image: photo != null
            ? DecorationImage(fit: BoxFit.cover, image: NetworkImage(photo))
            : null,
      ),
      child: photo != null
          ? null
          : const Icon(Icons.person, size: 30, color: AppColors.white),
    );

    return item;
  }
}

// soy extraordinaria
