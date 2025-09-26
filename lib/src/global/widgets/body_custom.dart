import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';
import 'package:lexxi/src/global/utils/change_colors.dart';
import 'package:lexxi/src/providers/data_user_provider.dart';
import 'package:lexxi/src/providers/grado_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomBody extends StatefulWidget {
  final Widget appBar;
  final Widget header;
  final String title;
  final bool needShortName;
  final Widget body;
  final bool needGrados;
  final bool automaticallyImplyLeading;
  final double expandedHeight;
  final Function(bool)? onhasScrolled;
  final Color backgroundColor;

  final Function(String, String)? changeGrade;

  const CustomBody({
    Key? key,
    required this.appBar,
    required this.header,
    required this.title,
    required this.body,
    this.needShortName = false,
    this.needGrados = false,
    this.expandedHeight = 0,
    this.onhasScrolled,
    this.backgroundColor = ColorPalette.primary,
    this.automaticallyImplyLeading = false,
    this.changeGrade,
  }) : super(key: key);

  @override
  State<CustomBody> createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  ValueNotifier<String> grado = ValueNotifier('');
  final ScrollController _scrollController = ScrollController();
  bool hasScrolled = false;
  bool loadFirtsGrado = false;
  final padd = const EdgeInsets.symmetric(horizontal: 10);

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (!hasScrolled && _scrollController.offset > 0) {
        hasScrolled = true;
        if (widget.onhasScrolled != null) {
          widget.onhasScrolled!(hasScrolled);
        }
      } else if (hasScrolled && _scrollController.offset <= 0) {
        hasScrolled = false;
        if (widget.onhasScrolled != null) {
          widget.onhasScrolled!(hasScrolled);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: SizedBox(
          width: 100.w,
          height: 100.h,
          child: Stack(
            children: [
              // Positioned(
              //   bottom: -300,
              //   child: Opacity(
              //     opacity: 0.3,
              //     child: Image.asset(
              //       'assets/astronauta.png',
              //       width: 100.w,
              //       height: 100.h,
              //     ),
              //   ),
              // ),
              Column(
                children: [
                  Padding(
                    padding: padd,
                    child: widget.appBar,
                  ),
                  Expanded(
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverAppBar(
                          pinned: false,
                          floating: false,
                          expandedHeight: widget.expandedHeight == 0
                              ? 45.w
                              : widget.expandedHeight,
                          automaticallyImplyLeading:
                              widget.automaticallyImplyLeading,
                          backgroundColor: Colors.transparent,
                          flexibleSpace: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              var top = constraints.biggest.height;
                              bool isExpanded = top > (kToolbarHeight + 40);
                              return FlexibleSpaceBar(
                                background: isExpanded
                                    ? Padding(
                                        padding: padd,
                                        child: widget.header
                                            .animate()
                                            .fadeIn(
                                                duration: const Duration(
                                                    milliseconds: 300))
                                            .moveY(
                                                begin: 50,
                                                end: 0,
                                                duration: const Duration(
                                                    milliseconds: 300)),
                                      )
                                    : Container(),
                              );
                            },
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                widget.title,
                                style: context.textTheme.titleLarge!.copyWith(
                                  color: blackToWhite(context),
                                ),
                              )
                                  .animate()
                                  .fadeIn(
                                      duration:
                                          const Duration(milliseconds: 300))
                                  .moveY(
                                      begin: 20,
                                      end: 0,
                                      duration:
                                          const Duration(milliseconds: 300)),
                            ),
                          ),
                        ),
                        if (widget.needGrados)
                          SliverToBoxAdapter(
                            child: ValueListenableBuilder(
                              valueListenable: context
                                  .read<DataUserProvider>()
                                  .userViewModel,
                              builder: (context, user, _) {
                                final grads = user.grado ?? [];
                                grado.value = grads.first.programCode!;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  final gradoProvider =
                                      Provider.of<GradoProvider>(context,
                                          listen: false);
                                  gradoProvider.idGrado = grads.first.id!;
                                });

                                if (!loadFirtsGrado) {
                                  if (widget.needShortName) {
                                    widget.changeGrade!(
                                        grads.first.programCode!,
                                        grads.first.programName!);
                                  } else {
                                    widget.changeGrade!(
                                        grads.first.programCode!,
                                        grads.first.programName!);
                                  }
                                  loadFirtsGrado = true;
                                }

                                return SizedBox(
                                  width: 100.w,
                                  height: 50,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: grads.map((e) {
                                      return GestureDetector(
                                        onTap: () {
                                          grado.value = e.programCode!;
                                          final gradoProvider =
                                              Provider.of<GradoProvider>(
                                                  context,
                                                  listen: false);
                                          gradoProvider.idGrado = e.id!;
                                          widget.changeGrade!(
                                              e.programCode!, e.programName!);
                                        },
                                        child: ValueListenableBuilder(
                                          valueListenable: grado,
                                          builder: (context, g, _) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                gradient: g == e.programCode!
                                                    ? AppColors
                                                        .linealGrdientGreen
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              margin: const EdgeInsets.all(8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Center(
                                                child: Text(
                                                  e.shortName!,
                                                  style: context
                                                      .textTheme.titleLarge!
                                                      .copyWith(
                                                    color: g == e.shortName!
                                                        ? whiteToBlack(context)
                                                        : blackToWhite(context),
                                                  ),
                                                ),
                                              ),
                                            ).animate().moveX(
                                                begin: 100,
                                                end: 0,
                                                duration: const Duration(
                                                    milliseconds: 300));
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),
                          ),
                        widget.body,
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
