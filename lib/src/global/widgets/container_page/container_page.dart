import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/device_size.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';
import 'package:lexxi/src/global/utils/change_colors.dart';
import 'package:lexxi/src/global/widgets/back_buttom.dart';
import 'package:lexxi/src/providers/state_app_bar_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ConatinerPage extends StatefulWidget {
  const ConatinerPage(
      {super.key,
      required this.chilHead,
      required this.childBody,
      this.customScroll = false,
      this.title,
      this.bottomBack = true,
      this.isGradintGrey = false,
      this.manualSize = false,
      this.height = 368,
      this.backgroundColor = false});

  final Widget chilHead, childBody;
  final bool customScroll;
  final String? title;
  final bool isGradintGrey;
  final bool bottomBack;
  final double height;
  final bool backgroundColor;
  final bool manualSize;

  @override
  State<ConatinerPage> createState() => _ConatinerPageState();
}

class _ConatinerPageState extends State<ConatinerPage>
    with SingleTickerProviderStateMixin {
  final bool _showAppBar = true;
  final ScrollController _scrollController = ScrollController();
  DeviceSize? deviceSize;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<StateAppBarProvider>().height = widget.height;
    });

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final appBarProvider = context.read<StateAppBarProvider>();
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // Cuando se hace scroll hacia arriba (top), muestra el app bar
      if (appBarProvider.hidden) {
        appBarProvider.hidden = false;
        appBarProvider.height = widget.height;
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      // Cuando se hace scroll hacia abajo (bottom), oculta el app bar
      if (!appBarProvider.hidden) {
        appBarProvider.hidden = true;
        appBarProvider.height = widget.height;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) async {
        if (value) {
          context.read<StateAppBarProvider>().hidden = true;
          context.read<StateAppBarProvider>().height = widget.height;
          // return true;
        }
      },
      child: Scaffold(
          appBar: _showAppBar
              ? _CustomAppBar(
                  isGradintGrey: widget.isGradintGrey,
                  bottomBack: widget.bottomBack,
                  manualSize: widget.manualSize,
                  height: context.read<StateAppBarProvider>().height,
                  color: widget.backgroundColor,
                  child: widget.chilHead)
              : null,
          body: SizedBox(
            width: 100.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.title != null)
                  Consumer<StateAppBarProvider>(builder: (context, value, _) {
                    return Container(
                        // color:
                        //     widget.backgroundColor ? AppColors.blueDark : null,
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Row(
                          mainAxisAlignment: value.hidden
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.spaceAround,
                          children: [
                            if (!value.hidden && widget.bottomBack)
                              GestureDetector(
                                onTap: () {
                                  context.read<StateAppBarProvider>().hidden =
                                      true;
                                  context.read<StateAppBarProvider>().height =
                                      widget.height;
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 40,
                                ),
                              ),
                            Text(
                              widget.title!,
                              style: context.textTheme.titleLarge!.copyWith(
                                color: blackToWhite(context),
                              ),
                            ),
                            !value.hidden
                                ? GestureDetector(
                                    onTap: () {
                                      final hidden = value.hidden;
                                      value.hidden = !hidden;
                                      value.height = widget.height;
                                    },
                                    child: const Icon(
                                      Icons.expand_more,
                                      size: 40,
                                    ),
                                  )
                                : Container()
                          ],
                        ));
                  }),
                Expanded(
                  // Agrega este widget
                  child: _customBody(),
                ),
              ],
            ),
          )),
    );
  }

  Widget _customBody() => widget.customScroll
      ? widget.childBody
      : ListView(
          controller: _scrollController,
          shrinkWrap: true,
          children: [widget.childBody],
        );
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({
    Key? key,
    required this.child,
    required this.isGradintGrey,
    // ignore: unused_element
    this.bottomBack = true,
    this.manualSize,
    required this.height,
    this.color,
  }) : super(key: key);
  final Widget child;
  final bool? isGradintGrey;
  final bool bottomBack;
  final double height;
  final bool? color;
  final bool? manualSize;

  @override
  Widget build(BuildContext context) {
    return Consumer<StateAppBarProvider>(builder: (context, value, _) {
      double h = manualSize!
          ? height
          : context.isSmall
              ? 40.h
              : height;
      return AnimatedContainer(
        width: 100.w,
        height: value.hidden ? h : 0,
        decoration: BoxDecoration(
          gradient: !color!
              ? (!isGradintGrey!
                  ? AppColors.linealGrdientGreen
                  : (context.darkmode
                      ? AppColors.linealGradientBlueDark
                      : AppColors.linealGGrey))
              : null,
          color: color! ? AppColors.blueDark : null,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(57.0),
            bottomLeft: Radius.circular(57.0),
          ),
          // boxShadow:  [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.16),
          //     offset: const Offset(0, 20.0),
          //     blurRadius: 21.0,
          //   ),
          // ],
        ),
        duration: const Duration(milliseconds: 300),
        child:
            // const Positioned(

            //   top: 40,
            //   left: 20,
            //   child: Mecha(w: 40,)),

            ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!bottomBack)
                        Container(
                          width: 100,
                          height: 50,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/logo_blanco.png'))),
                        ),
                      _bottomBack(context, bottomBack),
                      if (!isGradintGrey!)
                        GestureDetector(
                          onTap: () {
                            context.router.pushNamed('/profile');
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColors.blueDark,
                            child: _inconUser(),
                          ),
                        )
                    ],
                  ),
                ),
                Column(
                  children: [
                    child,
                    Container(
                      height: 1.h,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _bottomBack(BuildContext context, bool value) {
    Widget item = const BackButtom();
    if (!value) item = Container();
    return item;
  }

  Widget _inconUser() {
    Widget item = Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.linealGrdientGreen,
      ),
      child: const Icon(
        Icons.person_outline_outlined,
        size: 30,
        color: AppColors.blueDark,
      ),
    );
    if (isGradintGrey!) item = const Icon(Icons.person);

    if (isGradintGrey!) {
      item = ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (Rect bounds) =>
            AppColors.linealGrdientGreen.createShader(bounds),
        child: const Icon(
          Icons.person_outline_outlined,
          size: 30,
        ),
      );
    }
    print(isGradintGrey);
    return item;
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}



/* 
  - pagina que se agregue un grupo de personas por gerarquias
  - login 


  -------------------------------------------------------------


  admin general

  admin lider

  

 */