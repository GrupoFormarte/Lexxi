// src/screens/selection_program.dart

import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lexxi/aplication/academic_level/academic_level_use_case.dart';
import 'package:lexxi/aplication/auth/service/auth_service.dart';
import 'package:lexxi/aplication/item_dynamic/item_dynamic_use_case.dart';
import 'package:lexxi/domain/academic_level/model/academic_level.dart';
import 'package:lexxi/domain/auth/model/user.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/widgets/medalla_rive.dart';
import 'package:lexxi/src/pages/selected_programs/program_card.dart';
import 'package:lexxi/src/providers/data_user_provider.dart';
import 'package:lexxi/src/providers/grado_provider.dart';
import 'package:lexxi/src/routes/routes_import.gr.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

@RoutePage() // Anotación para rutas
class SelectionProgram extends StatefulWidget {
  const SelectionProgram({super.key});

  @override
  _SelectionProgramState createState() => _SelectionProgramState();
}

class _SelectionProgramState extends State<SelectionProgram> {
  String? selectedId;
  final itemUseCase = getIt.get<ItemDynamicUseCase>();
  final academyUse = getIt.get<AcademicLevelUseCase>();
  final ValueNotifier<List<Item>> preuniversitarios = ValueNotifier([]);
  late BuildContext _context;
  final ValueNotifier<AcademicLevelModel?> _valueNotifierAcademy =
      ValueNotifier(null);
  final AuthService _authService = getIt.get<AuthService>();

  @override
  void initState() {
    super.initState();
    _context = context;

    loadData();
  }

  Future<void> loadData() async {
    try {
      final items = await itemUseCase.getAllItems(collection: "Grados");
      // items.shuffle(); // Reorganizar la lista en orden aleatorio
      preuniversitarios.value = organizeItemsByCharacterCount(items);
      _valueNotifierAcademy.value =
          await academyUse.getAcademicLevelById(id: "668d39d63abc9ff60a7979d2");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los programas: $e')),
      );
    }
  }

  void _onItemTap(Item item) {
    setState(() {
      selectedId = item.id;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gradoProvider = Provider.of<GradoProvider>(context, listen: false);
      gradoProvider.idGrado = selectedId!;
    });

    _onNextPressed();
  }

  void _onNextPressed() async {
    if (selectedId != null) {
      final user = getIt.get<AuthService>();
      final dataUser = await user.getUserLocal();
      final selectedItem =
          preuniversitarios.value.firstWhere((item) => item.id == selectedId);
      final data = dataUser;
      data!.grado = [
        Grado.fromJson({
          "programCode": selectedItem.code,
          "programName": selectedItem.value,
          "shortName": selectedItem.shortName,
          "status": 1,
          "id": selectedItem.id
        })
      ];
      loadContext(data);
    }
  }

  loadContext(data) {
    _context.read<DataUserProvider>().userViewModel = data;
    _context.router.replaceNamed('/load_questions');
  }

  Widget _antorcha(
      {double width = 100,
      double height = 250,
      double opacity = 1,
      double angle = 0.0}) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        decoration: const BoxDecoration(
          color: AppColors.blueDark, // Fondo oscuro
        ),
        child: Stack(
          children: [
            // Positioned(
            //   right: -40,
            //   top: 70,
            //   child:
            //       _antorcha(width: 200, height: 550, angle: -0.5, opacity: 0.2),
            // ),
            // Positioned(
            //   left: -0.5,
            //   top: 500,
            //   child:
            //       _antorcha(width: 80, height: 180, angle: 0.5, opacity: 0.2),
            // ),

            // const AstronautScreen(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100.w,
                  height: 70,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      Container(
                        width: 100,
                        height: 50,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/lexxi.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () async {
                            await _authService.logout();
                            context.router.replaceAll([const SplashRoute()]);
                          },
                          child: const CircleAvatar(
                            radius: 15,
                            child: Icon(Icons.logout),
                          ))
                    ],
                  ),
                ),

                const SizedBox(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Por dónde Empezamos?',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<List<Item>>(
                    valueListenable: preuniversitarios,
                    builder: (context, programas, _) {
                      if (programas.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final programasConHijos = programas
                          .where((programa) => programa.childrents.isNotEmpty)
                          .toList();

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: programasConHijos.map((programa) {
                            final isSelected = programa.id == selectedId;

                            // return _buildProgramButton(programa.value!);
                            return ProgramCard(
                              programa: programa,
                              isSelected: isSelected,
                              onTap: () => _onItemTap(programa),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(
                  // height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Rétate,entrénate y hazlo',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _valueNotifierAcademy,
                        builder: (context, academy, _) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: academy == null
                                ? const Center(
                                    key: ValueKey('loading'),
                                    child:
                                        CircularProgressIndicator(), // Unique keys for AnimatedSwitcher
                                  )
                                : SizedBox(
                                    key: const ValueKey(
                                        'list'), // Unique keys for AnimatedSwitcher
                                    width: 100.w,
                                    height: 200,
                                    child: AnimatedListView(
                                      items: academy.typesLevels,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Botón "Siguiente" que aparece solo cuando hay una selección
                // Center(
                //   child: Container(
                //     width: 50, // Tamaño del botón
                //     height: 50, // Tamaño del botón
                //     margin: const EdgeInsets.all(20),
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: const Color(0xff01F5EE),
                //       border: Border.all(
                //         color: const Color(0xff01F5EE), // Color del borde
                //         width: 3, // Grosor del borde
                //       ),
                //     ),

                //     child: IconButton(
                //       icon: const Icon(
                //         Icons.arrow_forward, // Icono de "siguiente"
                //         color: AppColors.blueDark,
                //         size: 30,
                //       ),
                //       onPressed: _onNextPressed,
                //     ),
                //   ),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Item> organizeItemsByCharacterCount(List<Item> items) {
    List<Item> smallItems = [];
    List<Item> largeItems = [];
    if (items.isEmpty) return [];
    int totalLength = 0;
    int itemCount = 0;
    for (var item in items) {
      if (item.value != null && item.value!.trim().isNotEmpty) {
        totalLength += item.value!.trim().length;
        itemCount++;
      }
    }

    if (itemCount == 0) return []; // No hay nombres válidos

    int averageLength = (totalLength / itemCount).round();
    for (var item in items) {
      if (item.value != null && item.value!.trim().length <= averageLength) {
        smallItems.add(item);
      } else {
        largeItems.add(item);
      }
    }

    List<Item> organizedItems = [];
    int smallIndex = 0;
    int largeIndex = 0;
    while (smallIndex < smallItems.length || largeIndex < largeItems.length) {
      if (smallIndex < smallItems.length) {
        organizedItems.add(smallItems[smallIndex]);
        smallIndex++;
      }
      int largeAdded = 0;
      while (largeAdded < 2 && largeIndex < largeItems.length) {
        organizedItems.add(largeItems[largeIndex]);
        largeIndex++;
        largeAdded++;
      }
      if (smallIndex < smallItems.length) {
        organizedItems.add(smallItems[smallIndex]);
        smallIndex++;
      }
    }
    return organizedItems;
  }
}

class AnimatedListView extends StatefulWidget {
  final List<TypeLevel> items;

  const AnimatedListView({required this.items, Key? key}) : super(key: key);

  @override
  _AnimatedListViewState createState() => _AnimatedListViewState();
}

class _AnimatedListViewState extends State<AnimatedListView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final ScrollController _scrollController = ScrollController();
  final int _duplicateCount = 100; // Aumentar a 100 duplicaciones
  late final int _totalItems;
  late final List<Animation<double>> _animations;
  final bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _totalItems = widget.items.length * _duplicateCount;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animations = List.generate(_totalItems, (index) {
      final startDelay = (index % widget.items.length) * 0.1;
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(startDelay, startDelay + 0.5, curve: Curves.easeOut),
      );
    });

    Timer(const Duration(milliseconds: 300), () {
      _controller.forward();
    });

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final initialOffset = _scrollController.position.maxScrollExtent / 2;
        _scrollController.jumpTo(initialOffset);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isAnimating) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final threshold = maxScroll / _duplicateCount;

    if (_scrollController.position.pixels >= maxScroll - threshold) {
      _scrollController.jumpTo(_scrollController.position.pixels -
          threshold * (_duplicateCount / 2));
    } else if (_scrollController.position.pixels <= threshold) {
      _scrollController.jumpTo(_scrollController.position.pixels +
          threshold * (_duplicateCount / 2));
    }
  }

  double _calculateScale(int index, double scrollOffset, double viewportWidth) {
    double itemWidth = 120.0;
    double itemCenter = index * itemWidth + itemWidth / 2;
    double viewportCenter = scrollOffset + viewportWidth / 2;

    double distance = (itemCenter - viewportCenter).abs();
    double maxDistance = viewportWidth / 2 + itemWidth;
    double scale = 1 - (distance / maxDistance);
    return scale.clamp(0.6, 1.0);
  }

  double _calculateOpacity(
      int index, double scrollOffset, double viewportWidth) {
    double itemWidth = 120.0;
    double itemCenter = index * itemWidth + itemWidth / 2;
    double viewportCenter = scrollOffset + viewportWidth / 2;

    double distance = (itemCenter - viewportCenter).abs();
    double maxDistance = viewportWidth / 2 + itemWidth;

    double opacity = 1.0 - pow((distance / maxDistance), 4) * 9;
    return opacity.clamp(0.1, 1.0);
  }

  double _calculateTextOffset(
      int index, double scrollOffset, double viewportWidth) {
    double itemWidth = 120.0;
    double itemCenter = index * itemWidth + itemWidth / 2;
    double viewportCenter = scrollOffset + viewportWidth / 2;

    double distance = (itemCenter - viewportCenter).abs();
    double maxDistance = viewportWidth / 2 + itemWidth;

    double normalized = (1 - (distance / maxDistance)).clamp(0.0, 1.0);

    double maxOffset = 50.0; // Ajusta este valor según tus necesidades
    return (1 - normalized) * maxOffset;
  }

  double _calculateTextOpacity(
      int index, double scrollOffset, double viewportWidth) {
    double itemWidth = 120.0;
    double itemCenter = index * itemWidth + itemWidth / 2;
    double viewportCenter = scrollOffset + viewportWidth / 2;

    double distance = (itemCenter - viewportCenter).abs();
    double maxDistance = viewportWidth / 2 + itemWidth;

    double normalized = (1 - (distance / maxDistance)).clamp(0.0, 1.0);

    return normalized;
  }

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
            return ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: _totalItems,
              itemBuilder: (context, index) {
                final itemIndex = index % widget.items.length;

                final scale = _calculateScale(
                    index, _scrollController.offset, viewportWidth);
                final opacity = _calculateOpacity(
                    index, _scrollController.offset, viewportWidth);

                // Calcula el desplazamiento y la opacidad del texto
                final textOffset = _calculateTextOffset(
                    index, _scrollController.offset, viewportWidth);
                final textOpacity = _calculateTextOpacity(
                    index, _scrollController.offset, viewportWidth);

                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: MyRiveAnimation(
                                color: widget.items[itemIndex].getColor(),
                                previeColor: widget.items[itemIndex].getColor(),
                                level: "nivel_3",
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(180),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(
                                      "${widget.items[itemIndex].min} a ${widget.items[itemIndex].max}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.blueDark),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Transform.translate(
                          offset: Offset(0, textOffset),
                          child: Opacity(
                            opacity: textOpacity,
                            child: SizedBox(
                              width: 120,
                              child: Text(
                                widget.items[itemIndex].name!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
